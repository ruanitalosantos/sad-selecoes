-- =============================================================================
-- Item 1.1 do documento "Ajustes gerais pós Seleção Simplificada RAPS"
-- Cronograma: etapa exibida ao candidato divergindo do cronograma cadastrado
-- =============================================================================
--
-- CAUSA
-- A coluna "sad-selecoes".selecoes_cadastradas.etapa_atual só é recalculada
-- pelos triggers trg_atualizar_etapa_atual / trg_atualiza_etapa_selecao, que
-- disparam em INSERT OR UPDATE da tabela cronograma. Ou seja: a etapa só muda
-- quando alguém edita o cronograma, nunca quando a data simplesmente passa.
-- Por isso a seleção do RAPS seguia anunciando "INSCRIÇÕES ABERTAS" em
-- 27/07/2026, muito depois do término das inscrições.
--
-- SOLUÇÃO
-- Derivar a etapa das datas do cronograma no momento da LEITURA, e não da
-- escrita. A função abaixo devolve sempre a etapa coerente com o cronograma
-- cadastrado no painel administrativo, sem depender de trigger nem de job.
--
-- COMO APLICAR
-- 1. Rodar este arquivo inteiro no Postgres (cria/atualiza a função).
-- 2. Substituir a query do nó Postgres do workflow "selecoes-disponiveis"
--    pela query da seção [2].
-- 3. Opcional: agendar a seção [3] para manter a coluna materializada em dia
--    para quem ainda lê selecoes_cadastradas.etapa_atual diretamente.
-- =============================================================================


-- [1] FUNÇÃO: etapa derivada das datas do cronograma -------------------------
--
-- Regra de desempate, nesta ordem:
--   a) período com janela ainda aberta (hoje entre início e término) vence;
--   b) senão, o marco mais recente que já começou;
--   c) se nada começou, devolve o default 'aguardando publicação de edital'.
--
CREATE OR REPLACE FUNCTION "sad-selecoes".fn_etapa_atual_calculada(p_id_selecao integer)
RETURNS character varying
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    (
      SELECT m.rotulo
      FROM "sad-selecoes".cronograma cr
      CROSS JOIN LATERAL (VALUES
        ( 1, cr.inicio_inscricoes,                                  cr.termino_inscricoes,                                  'inscrições abertas'),
        ( 2, cr.termino_inscricoes,                                 NULL::date,                                             'inscrições encerradas'),
        ( 3, cr.inicio_impugnacao,                                  cr.termino_impugnacao,                                  'período de impugnação'),
        ( 4, cr.publicacao_concorrencia,                            NULL::date,                                             'concorrência publicada'),
        ( 5, cr.resultado_preliminar_pcd,                           NULL::date,                                             'resultado preliminar PCD'),
        ( 6, cr.inicio_recurso_pcd,                                 cr.termino_recurso_pcd,                                 'recursos ao resultado PCD'),
        ( 7, cr.resultado_definitivo_pcd,                           NULL::date,                                             'resultado definitivo PCD'),
        ( 8, cr.resultado_preliminar_analise_curricular,            NULL::date,                                             'resultado preliminar da análise curricular'),
        ( 9, cr.inicio_recurso_avaliacao_curricular,                cr.termino_recurso_avaliacao_curricular,                'recursos à avaliação curricular'),
        (10, cr.resultado_preliminar_ppni,                          NULL::date,                                             'resultado preliminar PPNI'),
        (11, cr.inicio_recurso_ppni,                                cr.termino_recurso_ppni,                                'recursos ao resultado PPNI'),
        (12, cr.convocacao_pcd,                                     NULL::date,                                             'convocação PCD'),
        (13, cr.inicio_avaliacao_pcd,                               cr.termino_avaliacao_pcd,                               'avaliação da equipe multiprofissional PCD'),
        (14, cr.publicacao_resultado_pcd,                           NULL::date,                                             'resultado da avaliação PCD'),
        (15, cr.inicio_recurso_resultado_preliminar_avaliacao_pcd,  cr.termino_recurso_resultado_preliminar_avaliacao_pcd,  'recursos à avaliação PCD'),
        (16, cr.resultado_final,                                    NULL::date,                                             'resultado final')
      ) AS m(ordem, inicio, fim, rotulo)
      WHERE cr.id_selecao = p_id_selecao
        AND m.inicio IS NOT NULL
        AND m.inicio <= (CURRENT_TIMESTAMP AT TIME ZONE 'America/Recife')::date
      ORDER BY
        -- janela ainda aberta tem precedência sobre marco já encerrado
        (m.fim IS NOT NULL
          AND (CURRENT_TIMESTAMP AT TIME ZONE 'America/Recife')::date <= m.fim) DESC,
        m.inicio DESC,
        m.ordem DESC
      LIMIT 1
    ),
    'aguardando publicação de edital'
  );
$$;

COMMENT ON FUNCTION "sad-selecoes".fn_etapa_atual_calculada(integer) IS
  'Devolve a etapa corrente da seleção derivada das datas do cronograma, avaliada no momento da consulta. Substitui a etapa materializada em selecoes_cadastradas.etapa_atual, que só era atualizada por trigger de escrita e ficava defasada com o passar do tempo.';


-- [2] QUERY DO NÓ "selecoes-disponiveis" -------------------------------------
--
-- Consumida por portal_inicial.html (tela "Selecione o certame desejado").
-- Cole no campo "Query" do nó Postgres, substituindo o conteúdo atual.
--
-- SELECT
--   s.id,
--   s.nome,
--   s.status,
--   "sad-selecoes".fn_etapa_atual_calculada(s.id) AS etapa_atual,
--   s.etapa_atual AS etapa_atual_materializada
-- FROM "sad-selecoes".selecoes_cadastradas s
-- ORDER BY s.nome;


-- [3] OPCIONAL: manter a coluna materializada em dia -------------------------
--
-- Só é necessário enquanto houver consulta lendo selecoes_cadastradas.etapa_atual
-- diretamente. Agende uma vez por dia (n8n Schedule Trigger ou pg_cron).
--
CREATE OR REPLACE FUNCTION "sad-selecoes".fn_sincronizar_etapa_atual()
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
  v_afetadas integer;
BEGIN
  UPDATE "sad-selecoes".selecoes_cadastradas s
     SET etapa_atual = "sad-selecoes".fn_etapa_atual_calculada(s.id),
         updated_at  = CURRENT_TIMESTAMP
   WHERE s.etapa_atual IS DISTINCT FROM "sad-selecoes".fn_etapa_atual_calculada(s.id);

  GET DIAGNOSTICS v_afetadas = ROW_COUNT;
  RETURN v_afetadas;
END;
$$;

COMMENT ON FUNCTION "sad-selecoes".fn_sincronizar_etapa_atual() IS
  'Realinha selecoes_cadastradas.etapa_atual com a etapa derivada do cronograma. Agendar diariamente. Devolve a quantidade de seleções atualizadas.';

-- Execução manual:
--   SELECT "sad-selecoes".fn_sincronizar_etapa_atual();

-- Conferência (compara o materializado com o calculado):
--   SELECT s.id, s.nome, s.status,
--          s.etapa_atual AS materializada,
--          "sad-selecoes".fn_etapa_atual_calculada(s.id) AS calculada
--     FROM "sad-selecoes".selecoes_cadastradas s
--    ORDER BY s.id;
