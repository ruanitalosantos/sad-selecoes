-- =============================================================================
-- Item 1.6 do documento "Ajustes gerais pós Seleção Simplificada RAPS"
-- Atualização cadastral: rastreabilidade das alterações e notificação da
-- Comissão Organizadora
-- =============================================================================
--
-- PROBLEMA
-- Hoje a atualização cadastral do candidato (e-mail, telefone, endereço)
-- sobrescreve o registro sem deixar rastro: não há como provar o que mudou,
-- quando mudou e qual era o valor anterior. Isso alimenta questionamentos do
-- tipo "não recebi a convocação porque o e-mail estava errado", sem que a
-- Comissão consiga demonstrar o histórico.
--
-- SOLUÇÃO
-- [1] Uma tabela de histórico, alimentada por trigger, registrando campo a
--     campo o valor anterior e o novo.
-- [2] Uma fila de notificação (a própria tabela, com a marca de envio) para o
--     n8n avisar a Comissão sem risco de perder ou duplicar aviso.
--
-- COMO APLICAR
-- 1. Rodar as seções [1] e [2].
-- 2. Na seção [3], trocar <TABELA_DE_INSCRICOES> pela tabela que guarda a
--    inscrição do candidato e rodar. A relação não está neste repositório:
--    confirme o nome no workflow n8n que grava a inscrição.
-- 3. Criar no n8n o fluxo da seção [4] (Schedule -> Postgres -> e-mail).
-- =============================================================================


-- [1] HISTÓRICO -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "sad-selecoes"."historico_atualizacao_cadastral" (
    "id"              bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "id_selecao"      integer,
    "inscricao"       character varying(50),
    "cpf"             character varying(11),
    "campo"           character varying(100)   NOT NULL,
    "valor_anterior"  text,
    "valor_novo"      text,
    "alterado_em"     timestamptz              NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "origem"          character varying(50)             DEFAULT 'portal-candidato',
    "notificado_em"   timestamptz
);

COMMENT ON TABLE "sad-selecoes"."historico_atualizacao_cadastral" IS
  'Trilha de auditoria das atualizações cadastrais feitas pelo candidato. Uma linha por campo alterado, com valor anterior e novo, para sustentar a defesa da Comissão em questionamentos sobre comunicação não recebida.';
COMMENT ON COLUMN "sad-selecoes"."historico_atualizacao_cadastral"."notificado_em" IS
  'Momento em que a Comissão foi avisada desta alteração. NULL = ainda na fila de notificação.';

CREATE INDEX IF NOT EXISTS "idx_hist_atualizacao_pendente"
    ON "sad-selecoes"."historico_atualizacao_cadastral" ("notificado_em")
    WHERE "notificado_em" IS NULL;

CREATE INDEX IF NOT EXISTS "idx_hist_atualizacao_cpf"
    ON "sad-selecoes"."historico_atualizacao_cadastral" ("cpf", "alterado_em" DESC);


-- [2] TRIGGER GENÉRICA ------------------------------------------------------
--
-- Compara OLD e NEW campo a campo e grava só o que mudou de fato. Os campos
-- monitorados são passados como argumentos na criação da trigger, então dá
-- para reaproveitar a mesma função em mais de uma tabela.
--
CREATE OR REPLACE FUNCTION "sad-selecoes".fn_log_atualizacao_cadastral()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_campo   text;
  v_antigo  text;
  v_novo    text;
  v_old     jsonb := to_jsonb(OLD);
  v_new     jsonb := to_jsonb(NEW);
BEGIN
  FOREACH v_campo IN ARRAY TG_ARGV LOOP
    v_antigo := v_old ->> v_campo;
    v_novo   := v_new ->> v_campo;

    -- IS DISTINCT FROM trata NULL corretamente (NULL -> valor conta como mudança)
    IF v_antigo IS DISTINCT FROM v_novo THEN
      INSERT INTO "sad-selecoes"."historico_atualizacao_cadastral"
             (id_selecao, inscricao, cpf, campo, valor_anterior, valor_novo)
      VALUES ((v_new ->> 'id_selecao')::integer,
               v_new ->> 'inscricao',
               v_new ->> 'cpf',
               v_campo,
               v_antigo,
               v_novo);
    END IF;
  END LOOP;

  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION "sad-selecoes".fn_log_atualizacao_cadastral() IS
  'Trigger de auditoria: grava em historico_atualizacao_cadastral cada campo alterado, entre os informados como argumentos da trigger.';


-- [3] LIGAR NA TABELA DE INSCRIÇÕES ------------------------------------------
--
-- Troque <TABELA_DE_INSCRICOES> pelo nome real antes de rodar. Ajuste também a
-- lista de campos monitorados conforme o que o portal permite atualizar.
--
-- DROP TRIGGER IF EXISTS trg_log_atualizacao_cadastral ON "sad-selecoes"."<TABELA_DE_INSCRICOES>";
--
-- CREATE TRIGGER trg_log_atualizacao_cadastral
--   AFTER UPDATE ON "sad-selecoes"."<TABELA_DE_INSCRICOES>"
--   FOR EACH ROW
--   EXECUTE FUNCTION "sad-selecoes".fn_log_atualizacao_cadastral(
--     'email', 'telefone', 'celular', 'cep', 'logradouro', 'numero',
--     'complemento', 'bairro', 'cidade', 'uf'
--   );


-- [4] FILA DE NOTIFICAÇÃO PARA O n8n -----------------------------------------
--
-- Fluxo sugerido: Schedule Trigger (a cada 15 min) -> Postgres (query A)
--                 -> IF houver linhas -> e-mail para a Comissão
--                 -> Postgres (query B, marcando como notificado).
--
-- A query A e a B usam a mesma janela de ids, então nenhuma alteração é
-- avisada duas vezes nem fica para trás se o envio falhar.
--
-- -- (A) o que ainda não foi avisado
-- SELECT h.id, h.alterado_em, h.cpf, h.inscricao, h.campo,
--        h.valor_anterior, h.valor_novo, s.nome AS selecao
--   FROM "sad-selecoes"."historico_atualizacao_cadastral" h
--   LEFT JOIN "sad-selecoes"."selecoes_cadastradas" s ON s.id = h.id_selecao
--  WHERE h.notificado_em IS NULL
--  ORDER BY h.alterado_em
--  LIMIT 500;
--
-- -- (B) marcar como avisado (passe os ids devolvidos em A)
-- UPDATE "sad-selecoes"."historico_atualizacao_cadastral"
--    SET notificado_em = CURRENT_TIMESTAMP
--  WHERE id = ANY($1::bigint[]);


-- [5] CONSULTAS DE APOIO -----------------------------------------------------
--
-- Histórico completo de um candidato (para responder a questionamento):
--   SELECT alterado_em, campo, valor_anterior, valor_novo
--     FROM "sad-selecoes"."historico_atualizacao_cadastral"
--    WHERE cpf = '00000000000'
--    ORDER BY alterado_em DESC;
--
-- Quem trocou e-mail depois da publicação do resultado:
--   SELECT h.*
--     FROM "sad-selecoes"."historico_atualizacao_cadastral" h
--     JOIN "sad-selecoes"."cronograma" c ON c.id_selecao = h.id_selecao
--    WHERE h.campo = 'email'
--      AND h.alterado_em::date > c.resultado_final
--    ORDER BY h.alterado_em DESC;
