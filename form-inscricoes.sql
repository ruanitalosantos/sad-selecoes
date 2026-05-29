-- ============================================================
--  SAD Seleções — Tabela principal de inscrições
--  Gerado a partir de formulario.html + transcricao_campos.csv
--  PostgreSQL 14+
-- ============================================================

CREATE TABLE IF NOT EXISTS inscricoes (

  -- ----------------------------------------------------------
  -- Metadados
  -- ----------------------------------------------------------
  id                        BIGSERIAL       PRIMARY KEY,
  created_at                TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
  updated_at                TIMESTAMPTZ     NOT NULL DEFAULT NOW(),

  -- ----------------------------------------------------------
  -- Identificação da seleção
  -- ----------------------------------------------------------
  id_selecao                VARCHAR(100),
  inscricao                 VARCHAR(50),                          -- número de inscrição
  token                     TEXT,                                 -- token de sessão/autenticação

  -- ----------------------------------------------------------
  -- Dados pessoais
  -- ----------------------------------------------------------
  nome                      VARCHAR(255)    NOT NULL,
  nome_social               VARCHAR(255),
  cpf                       VARCHAR(14)     NOT NULL UNIQUE,      -- formato: xxx.xxx.xxx-xx
  nasc                      DATE,                                 -- data de nascimento
  sexo                      VARCHAR(20),                          -- Masculino / Feminino
  genero                    VARCHAR(50),                          -- identidade de gênero
  genero_outro              VARCHAR(100),                         -- texto livre quando "Outro"
  raca                      VARCHAR(50),                          -- cor/raça (IBGE)
  estado_civil              VARCHAR(30),
  nacionalidade             VARCHAR(100),
  naturalidade_cidade       VARCHAR(100),
  naturalidade_uf           CHAR(2),
  mae                       VARCHAR(255),                         -- nome da mãe
  pai                       VARCHAR(255),                         -- nome do pai

  -- ----------------------------------------------------------
  -- Documento de identidade (RG)
  -- ----------------------------------------------------------
  rg_numero                 VARCHAR(30),
  rg_uf                     CHAR(2),
  rg_orgao                  VARCHAR(50),
  rg_data                   DATE,                                 -- data de expedição

  -- ----------------------------------------------------------
  -- Título de eleitor
  -- ----------------------------------------------------------
  titulo                    VARCHAR(20),
  secao                     VARCHAR(10),
  zona                      VARCHAR(10),

  -- ----------------------------------------------------------
  -- Serviço militar
  -- ----------------------------------------------------------
  militar                   BOOLEAN,                              -- quitação obrigatória
  alistamento_numero        VARCHAR(30),
  alistamento_orgao         VARCHAR(100),
  alistamento_data          DATE,

  -- ----------------------------------------------------------
  -- NIS
  -- ----------------------------------------------------------
  nis                       VARCHAR(20),

  -- ----------------------------------------------------------
  -- Contato
  -- ----------------------------------------------------------
  email                     VARCHAR(255),
  tel1                      VARCHAR(20),
  tel2                      VARCHAR(20),

  -- ----------------------------------------------------------
  -- Endereço residencial
  -- ----------------------------------------------------------
  cep                       VARCHAR(9),
  logradouro                VARCHAR(255),
  numero                    VARCHAR(20),
  complemento               VARCHAR(100),
  bairro                    VARCHAR(100),
  cidade                    VARCHAR(100),
  uf                        CHAR(2),

  -- ----------------------------------------------------------
  -- Vínculo com serviço público
  -- ----------------------------------------------------------
  vinculo_publico           VARCHAR(10),                          -- 'sim' | 'nao'
  vinculo_publico_opcao     VARCHAR(100),                         -- opção selecionada
  qual_vinculo              TEXT,                                 -- texto descritivo
  vinculo_orgao             VARCHAR(255),
  vinculo_cargo             VARCHAR(255),
  vinculo_tempo_servico     VARCHAR(50),

  -- ----------------------------------------------------------
  -- Parentesco com agentes políticos
  -- ----------------------------------------------------------
  politicos                 BOOLEAN,

  -- ----------------------------------------------------------
  -- Jurado(a)
  -- ----------------------------------------------------------
  foi_jurado                BOOLEAN,
  jurado_funcao             VARCHAR(50),
  jurado_periodo            TEXT,

  -- ----------------------------------------------------------
  -- Pessoa com Deficiência (PCD)
  -- ----------------------------------------------------------
  is_pcd                    BOOLEAN,
  tipo_pcd                  VARCHAR(100),
  pcd_cid                   VARCHAR(20),
  condicao_especial         BOOLEAN,                              -- necessita condição especial?
  necessidade               TEXT,                                 -- descrição da condição

  -- ----------------------------------------------------------
  -- Cotas PPNI (Preto, Pardo, Negro Indígena)
  -- ----------------------------------------------------------
  cotas_ppni                BOOLEAN,

  -- ----------------------------------------------------------
  -- Candidatura
  -- ----------------------------------------------------------
  nivel                     VARCHAR(50),                          -- Superior / Técnico / etc.
  cargo                     VARCHAR(100),
  especialidade             VARCHAR(100),

  -- ----------------------------------------------------------
  -- Formação acadêmica
  -- ----------------------------------------------------------
  ies                       VARCHAR(255),                         -- instituição de ensino
  curso                     VARCHAR(255),
  ano_conclusao             SMALLINT,

  -- ----------------------------------------------------------
  -- Documentos enviados (URLs/caminhos dos arquivos)
  -- ----------------------------------------------------------
  doc_id_frente             TEXT,                                 -- documento de identidade (frente)
  doc_id_verso              TEXT,                                 -- documento de identidade (verso)
  doc_cpf                   TEXT,
  doc_quitacao_eleitoral    TEXT,
  doc_militar               TEXT,                                 -- quitação serviço militar
  doc_jurado                TEXT,                                 -- certificado de jurado(a)
  doc_declaracao_deficiencia TEXT,
  doc_laudo_medico_pcd      TEXT,
  doc_ppni_foto_frontal     TEXT,
  doc_ppni_foto_perfil      TEXT,
  doc_ppni_video            TEXT,
  doc_ppni_termo            TEXT,
  doc_ppni_rg               TEXT,
  doc_escolaridade          TEXT,                                 -- requisitos básicos de escolaridade
  doc_curriculo             TEXT,                                 -- titulação e experiência profissional

  -- ----------------------------------------------------------
  -- Análise curricular (preenchido pelo avaliador)
  -- ----------------------------------------------------------
  analisecurricular         TEXT,
  justcurricular            TEXT,                                 -- justificativa análise curricular

  -- ----------------------------------------------------------
  -- Análise de cotas (preenchido pelo avaliador)
  -- ----------------------------------------------------------
  analisecotas              TEXT,
  justcotas                 TEXT,                                 -- justificativa análise cotas

  -- ----------------------------------------------------------
  -- Análise PCD (preenchido pelo avaliador)
  -- ----------------------------------------------------------
  analisepcd                TEXT,
  justpcd                   TEXT,                                 -- justificativa análise PCD
  resultado_pericia         TEXT,

  -- ----------------------------------------------------------
  -- Avaliação PM (preenchido pelo avaliador)
  -- ----------------------------------------------------------
  avaliarpm                 TEXT,

  -- ----------------------------------------------------------
  -- Notas — Prova de títulos
  -- ----------------------------------------------------------
  nmestrado                 NUMERIC(5,2),
  ndoutorado                NUMERIC(5,2),
  nespecializacao           NUMERIC(5,2),
  nconcresid                NUMERIC(5,2),                         -- nota certificado de residência
  notaexperiencia           NUMERIC(5,2),
  nprovatitulos             NUMERIC(5,2),                         -- média notas prova de títulos
  nota                      NUMERIC(5,2),                         -- nota final
  novanota                  NUMERIC(5,2),                         -- nota final (pós ajuste)

  -- ----------------------------------------------------------
  -- Notas pós-recurso
  -- ----------------------------------------------------------
  nmestradopr               NUMERIC(5,2),
  ndoutoradopr              NUMERIC(5,2),
  nespecializacaopr         NUMERIC(5,2),
  nconcresidpr              NUMERIC(5,2),
  notaexperienciapr         NUMERIC(5,2),
  nprovatitulospr           NUMERIC(5,2),

  -- ----------------------------------------------------------
  -- Notas formação e experiência (campos complementares)
  -- ----------------------------------------------------------
  notaformacao              BIGINT,
  descricaoformacao         VARCHAR(255),
  nota_exp1                 BIGINT,
  notaexp2                  BIGINT,                               -- nota experiência profissional (até 20)
  notaformacaopr            BIGINT,                               -- nota formação pós-recurso
  descformacaopr            VARCHAR(255),
  notaformpr                BIGINT,

  -- ----------------------------------------------------------
  -- Recursos
  -- ----------------------------------------------------------
  possuirecurso             BOOLEAN,
  justreccurriculo          TEXT,                                 -- justificativa recurso curricular
  justrecpcd                TEXT,                                 -- justificativa recurso PCD
  justreccotas              TEXT,                                 -- justificativa recurso cotas
  justrecursos              TEXT,                                 -- justificativa julgamento de recursos
  julcurricular             TEXT,                                 -- julgamento de recursos curricular
  julpcd                    TEXT,                                 -- julgamento de recursos PCD
  julcotas                  TEXT,                                 -- julgamento de recursos cotas

  -- ----------------------------------------------------------
  -- Status e controle
  -- ----------------------------------------------------------
  criisppni                 VARCHAR(255),                         -- resultado comissão PPNI
  criispcd                  VARCHAR(255),                         -- resultado comissão PCD
  result_prazo_rec_inscricao VARCHAR(255),                        -- resultado prazo recurso inscrição
  atividadehabilit          VARCHAR(255)                          -- id-ativ / atividade habilitada

);

-- ----------------------------------------------------------
-- Índices
-- ----------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_inscricoes_cpf        ON inscricoes (cpf);
CREATE INDEX IF NOT EXISTS idx_inscricoes_id_selecao ON inscricoes (id_selecao);
CREATE INDEX IF NOT EXISTS idx_inscricoes_inscricao  ON inscricoes (inscricao);
CREATE INDEX IF NOT EXISTS idx_inscricoes_cargo      ON inscricoes (cargo);
CREATE INDEX IF NOT EXISTS idx_inscricoes_nivel      ON inscricoes (nivel);
CREATE INDEX IF NOT EXISTS idx_inscricoes_created_at ON inscricoes (created_at);

-- ----------------------------------------------------------
-- Trigger: atualiza updated_at automaticamente
-- ----------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS set_updated_at ON inscricoes;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON inscricoes
  FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();
