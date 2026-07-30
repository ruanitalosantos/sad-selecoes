# SAD - Seleções

Este repositório contém o código-fonte e recursos para o sistema de seleções da Secretaria de Administração (SAD). 

## Estrutura do Projeto

O projeto é composto por interfaces web em HTML e scripts de banco de dados e automação:

- **Interfaces Web**:
  - `portal.html` / `portal_inicial.html` / `portal-l.html`: Portal principal de acesso.
  - `admin.html` / `admin-portal.html`: Painel administrativo.
  - `formulario.html` / `form_original.html`: Formulários de inscrição.

- **Banco de Dados (SQL)**:
  - `sad-selecoes-tabelasbanco.sql`: Estrutura das tabelas do banco de dados.
  - `form-inscricoes.sql`: Consultas e inserções relacionadas às inscrições.
  - `n8n-portal-certame-query-corrigida.sql`: Queries otimizadas para o portal.

- **Automação & Integração**:
  - `n8n-crud-sadselecoes.json`: Workflow do n8n para operações de CRUD e integração de dados.
  - `refactor_modals.py`: Script Python utilitário.
  - `transcricao_campos.csv`: Dicionário de dados ou de-para de campos.

## Tecnologias Utilizadas

- **Frontend**: HTML, CSS, JavaScript (Interfaces de usuário)
- **Banco de Dados**: SQL
- **Automação**: n8n (Workflows e Integração)
- **Utilitários**: Python
