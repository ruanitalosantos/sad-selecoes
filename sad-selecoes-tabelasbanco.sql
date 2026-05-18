-- Adminer 5.4.2 PostgreSQL 15.7 dump

DROP TABLE IF EXISTS "comunicados";
CREATE TABLE "sad-selecoes"."comunicados" (
    "id" text NOT NULL,
    "descricao" text NOT NULL,
    "mimetype" text NOT NULL,
    "url" text NOT NULL,
    "data" timestamp NOT NULL,
    "id_selecao" integer,
    CONSTRAINT "comunicados_sshvr_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

COMMENT ON TABLE "sad-selecoes"."comunicados" IS 'Tabela que armazena comunicados relacionados ao processo seletivo SSHVR, incluindo descrições, tipos de mídia, URLs de download e datas de publicação.';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."id" IS 'Identificador único do comunicado.';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."descricao" IS 'Descreve o assunto ou título do comunicado.';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."mimetype" IS 'Tipo de mídia do arquivo associado ao comunicado (por exemplo, application/pdf para arquivos PDF).';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."url" IS 'URL de download do arquivo do comunicado.';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."data" IS 'Data e hora de publicação do comunicado.';

COMMENT ON COLUMN "sad-selecoes"."comunicados"."id_selecao" IS 'Identificador da seleção. Valores conhecidos: 1. Este campo estabelece uma relação com a entidade de seleções, permitindo vincular cada comunicado a uma seleção específica.';


DROP TABLE IF EXISTS "cronograma";
DROP SEQUENCE IF EXISTS "sad-selecoes".cronograma_id_seq;
CREATE SEQUENCE "sad-selecoes".cronograma_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;

CREATE TABLE "sad-selecoes"."cronograma" (
    "id" integer DEFAULT nextval('cronograma_id_seq'),
    "inicio_inscricoes" date,
    "termino_inscricoes" date,
    "inicio_impugnacao" date,
    "termino_impugnacao" date,
    "publicacao_concorrencia" date,
    "resultado_preliminar_pcd" date,
    "inicio_recurso_pcd" date,
    "termino_recurso_pcd" date,
    "resultado_definitivo_pcd" date,
    "resultado_preliminar_analise_curricular" date,
    "resultado_preliminar_ppni" date,
    "inicio_recurso_avaliacao_curricular" date,
    "termino_recurso_avaliacao_curricular" date,
    "convocacao_pcd" date,
    "inicio_avaliacao_pcd" date,
    "termino_avaliacao_pcd" date,
    "publicacao_resultado_pcd" date,
    "inicio_recurso_resultado_preliminar_avaliacao_pcd" date,
    "termino_recurso_resultado_preliminar_avaliacao_pcd" date,
    "resultado_final" date,
    "inicio_recurso_ppni" date,
    "termino_recurso_ppni" date,
    "updated_at" timestamptz,
    "id_selecao" integer
)
WITH (oids = false);

COMMENT ON TABLE "sad-selecoes"."cronograma" IS 'Tabela de cronograma de seleções, armazenando informações sobre as datas importantes do processo seletivo.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."id" IS 'Identificador único do cronograma de seleção.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_inscricoes" IS 'Data de início das inscrições para o processo seletivo.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_inscricoes" IS 'Data de término das inscrições para o processo seletivo.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_impugnacao" IS 'Data de início do período de impugnação.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_impugnacao" IS 'Data de término do período de impugnação.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."publicacao_concorrencia" IS 'Data de publicação da concorrência.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."resultado_preliminar_pcd" IS 'Data do resultado preliminar da PCD (Pessoas com Deficiência).';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_recurso_pcd" IS 'Data de início do recurso da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_recurso_pcd" IS 'Data de término do recurso da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."resultado_definitivo_pcd" IS 'Data do resultado definitivo da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."resultado_preliminar_analise_curricular" IS 'Data do resultado preliminar da análise curricular.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."resultado_preliminar_ppni" IS 'Data do resultado preliminar da PPNI (Pessoas com Necessidades Insólitas).';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_recurso_avaliacao_curricular" IS 'Data de início do recurso da avaliação curricular.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_recurso_avaliacao_curricular" IS 'Data de término do recurso da avaliação curricular.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."convocacao_pcd" IS 'Data de convocação da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_avaliacao_pcd" IS 'Data de início da avaliação da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_avaliacao_pcd" IS 'Data de término da avaliação da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."publicacao_resultado_pcd" IS 'Data de publicação do resultado da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_recurso_resultado_preliminar_avaliacao_pcd" IS 'Data de início do recurso do resultado preliminar da avaliação da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_recurso_resultado_preliminar_avaliacao_pcd" IS 'Data de término do recurso do resultado preliminar da avaliação da PCD.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."resultado_final" IS 'Data do resultado final do processo seletivo.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."inicio_recurso_ppni" IS 'Data de início do recurso da PPNI.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."termino_recurso_ppni" IS 'Data de término do recurso da PPNI.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."updated_at" IS 'Data e hora da última atualização do registro.';

COMMENT ON COLUMN "sad-selecoes"."cronograma"."id_selecao" IS 'Identificador da seleção, foreign key que referencia a tabela de seleções. Valores conhecidos: 1, 2.';


DELIMITER ;;

CREATE TRIGGER "trg_atualiza_etapa_selecao" AFTER INSERT OR UPDATE ON "sad-selecoes"."cronograma" FOR EACH ROW EXECUTE FUNCTION fn_atualiza_etapa_selecao();;

CREATE TRIGGER "trg_atualizar_etapa_atual" AFTER INSERT OR UPDATE ON "sad-selecoes"."cronograma" FOR EACH ROW EXECUTE FUNCTION trg_fn_atualizar_etapa_atual();;

DELIMITER ;

DROP TABLE IF EXISTS "estrutura_html_forms";
DROP SEQUENCE IF EXISTS "sad-selecoes".estrutura_html_forms_id_seq;
CREATE SEQUENCE "sad-selecoes".estrutura_html_forms_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "sad-selecoes"."estrutura_html_forms" (
    "id" integer DEFAULT nextval('estrutura_html_forms_id_seq') NOT NULL,
    "id_selecao" integer NOT NULL,
    "form" text NOT NULL,
    "processid" character varying(255) NOT NULL,
    "cd_consultar_inscricao" character varying(255) NOT NULL,
    "hash_form" character varying(255) DEFAULT '1KoQvLWm_mRo5GLGVyD4kPy9Xl7lZE6qr' NOT NULL,
    "multiplas_inscricoes" boolean DEFAULT false NOT NULL,
    "cargos" jsonb,
    CONSTRAINT "estrutura_html_forms_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

COMMENT ON TABLE "sad-selecoes"."estrutura_html_forms" IS 'Tabela responsável por armazenar estruturas de formulários HTML para secciones, com informações sobre o processo de inscrição e cargos disponíveis.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."id" IS 'Identificador único da estrutura do formulário.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."id_selecao" IS 'Referência à seleção (tabela não especificada, presume-se uma tabela de seleções) à qual o formulário pertence. Ex.: id_selecao = 1 pode se referir à ''Seleção 1'', id_selecao = 2 pode se referir à ''Seleção 2''.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."form" IS 'Estrutura do formulário HTML.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."processid" IS 'Identificador do processo de inscrição.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."cd_consultar_inscricao" IS 'Código para consultar a inscrição.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."hash_form" IS 'Hash do formulário para segurança e validação.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."multiplas_inscricoes" IS 'Flag: False = Inscrições únicas permitidas, True = Múltiplas inscrições permitidas.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_forms"."cargos" IS 'Lista de cargos disponíveis no formato JSON, contendo informações sobre os cargos ofertados na seção.';

CREATE INDEX idx_id_selecao ON "sad-selecoes".estrutura_html_forms USING btree (id_selecao);


DROP TABLE IF EXISTS "estrutura_html_portais";
CREATE TABLE "sad-selecoes"."estrutura_html_portais" (
    "id_selecao" bigint NOT NULL,
    "selecao" text,
    "conteudo" text,
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "url_recurso" text,
    "mascara_inscricao" text,
    "edital" text,
    "descricao" text,
    "url_formulario" text
)
WITH (oids = false);

COMMENT ON TABLE "sad-selecoes"."estrutura_html_portais" IS 'Tabela de estrutura de portais de seleções, armazenando informações sobre seleções públicas, editais e recursos relacionados.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."id_selecao" IS 'Identificador único da seleção, servindo como chave primária para relacionar informações específicas de cada seleção.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."selecao" IS 'Nome ou descrição da seleção, indicando o tipo de processo seletivo ou edital em questão.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."conteudo" IS 'Detalhes oder informações adicionais sobre a seleção, podendo incluir descrições de vagas, requisitos ou procedimentos.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."created_at" IS 'Data e hora em que o registro foi criado no sistema, ajudando a rastrear a origem e o histórico de atualizações.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."updated_at" IS 'Data e hora da última atualização do registro, permitindo o acompanhamento das alterações realizadas.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."url_recurso" IS 'Endereço URL de recursos adicionais, como formulários, editais ou instruções específicas para a seleção.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."mascara_inscricao" IS 'Máscara ou padrão para inscrições, possivelmente usado para identificar ou validar inscrições de acordo com regras pré-definidas.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."edital" IS 'Texto do edital da seleção, que pode incluir detalhes sobre o processo, critérios de seleção, cronograma e resultados.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."descricao" IS 'Descrição resumida ou adicional sobre a seleção, auxiliando na compreensão do processo seletivo ou do edital.';

COMMENT ON COLUMN "sad-selecoes"."estrutura_html_portais"."url_formulario" IS 'Endereço URL do formulário de inscrição ou de outra etapa do processo, facilitando o acesso direto pelo usuário.';

CREATE INDEX idx_estrutura_id_selecao ON "sad-selecoes".estrutura_html_portais USING btree (id_selecao);


DROP TABLE IF EXISTS "selecoes_cadastradas";
CREATE TABLE "sad-selecoes"."selecoes_cadastradas" (
    "id" integer DEFAULT GENERATED ALWAYS AS IDENTITY NOT NULL,
    "nome" character varying(255) NOT NULL,
    "inserido_por" character varying(255),
    "status" character varying(50) DEFAULT 'Ativo',
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP,
    "etapa_atual" character varying(100) DEFAULT 'aguardando publicação de edital',
    "hash_drive" text DEFAULT '1wyBE9x0KiexFZVVeG2mly55_s7C_fBMO',
    CONSTRAINT "selecoes_cadastradas_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

COMMENT ON TABLE "sad-selecoes"."selecoes_cadastradas" IS 'Tabela responsável por armazenar seleções cadastradas, incluindo informações sobre o nome da seleção, usuário que a inseriu, status atual, data de criação e atualização, etapa atual do processo e um identificador único no Drive.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."id" IS 'Identificador único da seleção cadastrada, utilizado como chave primária.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."nome" IS 'Nome da seleção cadastrada, representando a identidade da seleção.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."inserido_por" IS 'Usuário responsável por inserir a seleção no sistema, facilitando o rastreamento de operações.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."status" IS 'Flag que indica o status atual da seleção, podendo ser: Ativo.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."created_at" IS 'Data e hora em que a seleção foi criada no sistema, servindo como registro histórico.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."updated_at" IS 'Data e hora da última atualização da seleção no sistema, permitindo o acompanhamento de mudanças.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."etapa_atual" IS 'Etapa corrente do processo da seleção, indicando o estágio em que se encontra.';

COMMENT ON COLUMN "sad-selecoes"."selecoes_cadastradas"."hash_drive" IS 'Identificador único no Drive associado à seleção, permitindo a integração com recursos externos.';


DELIMITER ;;

CREATE TRIGGER "trg_etapa_atual_selecao" BEFORE INSERT ON "sad-selecoes"."selecoes_cadastradas" FOR EACH ROW EXECUTE FUNCTION trg_fn_etapa_atual_selecao();;

DELIMITER ;

ALTER TABLE ONLY "sad-selecoes"."cronograma" ADD CONSTRAINT "fk_cronograma_selecoes_cadastradas" FOREIGN KEY (id_selecao) REFERENCES selecoes_cadastradas(id);

ALTER TABLE ONLY "sad-selecoes"."estrutura_html_forms" ADD CONSTRAINT "fk_selecao" FOREIGN KEY (id_selecao) REFERENCES selecoes_cadastradas(id);

ALTER TABLE ONLY "sad-selecoes"."estrutura_html_portais" ADD CONSTRAINT "fk_selecao" FOREIGN KEY (id_selecao) REFERENCES selecoes_cadastradas(id);

-- 2026-05-18 12:20:09 UTC
