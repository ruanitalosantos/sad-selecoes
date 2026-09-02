-- =============================================================================
-- Item 1.9 do documento "Ajustes gerais pós Seleção Simplificada RAPS"
-- Canais de suporte: e-mail de atendimento editável por certame
-- =============================================================================
--
-- PROBLEMA
-- O e-mail gggest.sad@recife.pe.gov.br estava escrito direto no HTML do portal
-- (portal.html e portal-l.html), então todo certame exibia o mesmo endereço e
-- só era possível trocá-lo alterando o código.
--
-- SOLUÇÃO
-- Uma coluna por seleção, lida pela mesma query que já monta o portal. O HTML
-- passou a ler o valor de <div id="suporte-email-data">{{ $json.email_suporte }}</div>
-- e, quando ele vem vazio, mantém o endereço padrão da SAD.
--
-- COMO APLICAR
-- 1. Rodar a seção [1].
-- 2. Trocar a query do nó "Buscar cronograma" pela versão da seção [2]
--    (é a query de n8n-portal-certame-query-corrigida.sql acrescida de duas
--    colunas: email_suporte e o avisos_html que já existia).
-- 3. No Portal SAD ADM, o campo novo aparece no cadastro da seleção.
-- =============================================================================


-- [1] COLUNA -----------------------------------------------------------------
ALTER TABLE "sad-selecoes"."estrutura_html_portais"
    ADD COLUMN IF NOT EXISTS "email_suporte" character varying(255);

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."email_suporte" IS
  'E-mail de atendimento eletrônico exibido no bloco "Canais de suporte" do portal do certame. Vazio faz o portal manter o endereço padrão da SAD.';

-- Semente: mantém o comportamento atual para as seleções já cadastradas.
UPDATE "sad-selecoes"."estrutura_html_portais"
   SET email_suporte = 'gggest.sad@recife.pe.gov.br'
 WHERE email_suporte IS NULL;


-- [2] QUERY DO NÓ "Buscar cronograma" ----------------------------------------
--
-- Substitui a query atual. Diferença em relação a
-- n8n-portal-certame-query-corrigida.sql: a coluna ep.email_suporte.
--
-- SELECT
--     TO_CHAR(cr.inicio_inscricoes, 'YYYY-MM-DD') AS inicio_inscricoes,
--     TO_CHAR(cr.termino_inscricoes, 'YYYY-MM-DD') AS termino_inscricoes,
--     TO_CHAR(cr.inicio_impugnacao, 'YYYY-MM-DD') AS inicio_impugnacao,
--     TO_CHAR(cr.termino_impugnacao, 'YYYY-MM-DD') AS termino_impugnacao,
--     TO_CHAR(cr.publicacao_concorrencia, 'YYYY-MM-DD') AS publicacao_concorrencia,
--     TO_CHAR(cr.resultado_preliminar_pcd, 'YYYY-MM-DD') AS resultado_preliminar_pcd,
--     TO_CHAR(cr.inicio_recurso_pcd, 'YYYY-MM-DD') AS inicio_recurso_pcd,
--     TO_CHAR(cr.termino_recurso_pcd, 'YYYY-MM-DD') AS termino_recurso_pcd,
--     TO_CHAR(cr.resultado_definitivo_pcd, 'YYYY-MM-DD') AS resultado_definitivo_pcd,
--     TO_CHAR(cr.resultado_preliminar_analise_curricular, 'YYYY-MM-DD') AS resultado_preliminar_analise_curricular,
--     TO_CHAR(cr.resultado_preliminar_ppni, 'YYYY-MM-DD') AS resultado_preliminar_ppni,
--     TO_CHAR(cr.inicio_recurso_avaliacao_curricular, 'YYYY-MM-DD') AS inicio_recurso_avaliacao_curricular,
--     TO_CHAR(cr.termino_recurso_avaliacao_curricular, 'YYYY-MM-DD') AS termino_recurso_avaliacao_curricular,
--     TO_CHAR(cr.convocacao_pcd, 'YYYY-MM-DD') AS convocacao_pcd,
--     TO_CHAR(cr.inicio_avaliacao_pcd, 'YYYY-MM-DD') AS inicio_avaliacao_pcd,
--     TO_CHAR(cr.termino_avaliacao_pcd, 'YYYY-MM-DD') AS termino_avaliacao_pcd,
--     TO_CHAR(cr.publicacao_resultado_pcd, 'YYYY-MM-DD') AS publicacao_resultado_pcd,
--     TO_CHAR(cr.inicio_recurso_resultado_preliminar_avaliacao_pcd, 'YYYY-MM-DD') AS inicio_recurso_resultado_preliminar_avaliacao_pcd,
--     TO_CHAR(cr.termino_recurso_resultado_preliminar_avaliacao_pcd, 'YYYY-MM-DD') AS termino_recurso_resultado_preliminar_avaliacao_pcd,
--     TO_CHAR(cr.inicio_recurso_ppni, 'YYYY-MM-DD') AS inicio_recurso_ppni,
--     TO_CHAR(cr.termino_recurso_ppni, 'YYYY-MM-DD') AS termino_recurso_ppni,
--     TO_CHAR(cr.resultado_final, 'YYYY-MM-DD') AS resultado_final,
--   ep.selecao,
--   ep.conteudo,
--   ep.url_recurso,
--   ep.mascara_inscricao,
--   ep.edital,
--   ep.descricao,
--   ep.updated_at,
--   COALESCE(NULLIF(TRIM(ep.email_suporte), ''), 'gggest.sad@recife.pe.gov.br') AS email_suporte,
--   COALESCE(
--     (SELECT string_agg('<p class="mb-0 aviso-item">' || a.mensagem || '</p>', '<hr class="aviso-divider">' ORDER BY a.created_at DESC)
--      FROM "sad-selecoes".avisos a
--      WHERE a.id_selecao = cr.id_selecao AND a.ativo = true),
--     ''
--   ) AS avisos_html
-- FROM "sad-selecoes".cronograma cr
--   JOIN "sad-selecoes".estrutura_html_portais ep
--   ON ep.id_selecao = cr.id_selecao
-- WHERE cr.id_selecao = {{ $('direcionar portal').item.json.query.id }}


-- [3] CONFERÊNCIA ------------------------------------------------------------
--   SELECT id_selecao, selecao, email_suporte
--     FROM "sad-selecoes"."estrutura_html_portais"
--    ORDER BY id_selecao;
