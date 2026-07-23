-- Query corrigida do nó "Buscar cronograma" (workflow "portal-certame")
-- Única mudança: acrescenta a coluna avisos_html no final do SELECT.
-- Quando há mais de um aviso ativo, eles vêm separados por <hr class="aviso-divider">
-- (estilizado no CSS do portal.html/portal-l.html) e ordenados do mais recente para o mais antigo.
-- Cole isto no campo "Query" do nó Postgres "Buscar cronograma", substituindo o conteúdo atual.

SELECT
    TO_CHAR(cr.inicio_inscricoes, 'YYYY-MM-DD') AS inicio_inscricoes,
    TO_CHAR(cr.termino_inscricoes, 'YYYY-MM-DD') AS termino_inscricoes,
    TO_CHAR(cr.inicio_impugnacao, 'YYYY-MM-DD') AS inicio_impugnacao,
    TO_CHAR(cr.termino_impugnacao, 'YYYY-MM-DD') AS termino_impugnacao,
    TO_CHAR(cr.publicacao_concorrencia, 'YYYY-MM-DD') AS publicacao_concorrencia,
    TO_CHAR(cr.resultado_preliminar_pcd, 'YYYY-MM-DD') AS resultado_preliminar_pcd,
    TO_CHAR(cr.inicio_recurso_pcd, 'YYYY-MM-DD') AS inicio_recurso_pcd,
    TO_CHAR(cr.termino_recurso_pcd, 'YYYY-MM-DD') AS termino_recurso_pcd,
    TO_CHAR(cr.resultado_definitivo_pcd, 'YYYY-MM-DD') AS resultado_definitivo_pcd,
    TO_CHAR(cr.resultado_preliminar_analise_curricular, 'YYYY-MM-DD') AS resultado_preliminar_analise_curricular,
    TO_CHAR(cr.resultado_preliminar_ppni, 'YYYY-MM-DD') AS resultado_preliminar_ppni,
    TO_CHAR(cr.inicio_recurso_avaliacao_curricular, 'YYYY-MM-DD') AS inicio_recurso_avaliacao_curricular,
    TO_CHAR(cr.termino_recurso_avaliacao_curricular, 'YYYY-MM-DD') AS termino_recurso_avaliacao_curricular,
    TO_CHAR(cr.convocacao_pcd, 'YYYY-MM-DD') AS convocacao_pcd,
    TO_CHAR(cr.inicio_avaliacao_pcd, 'YYYY-MM-DD') AS inicio_avaliacao_pcd,
    TO_CHAR(cr.termino_avaliacao_pcd, 'YYYY-MM-DD') AS termino_avaliacao_pcd,
    TO_CHAR(cr.publicacao_resultado_pcd, 'YYYY-MM-DD') AS publicacao_resultado_pcd,
    TO_CHAR(cr.inicio_recurso_resultado_preliminar_avaliacao_pcd, 'YYYY-MM-DD') AS inicio_recurso_resultado_preliminar_avaliacao_pcd,
    TO_CHAR(cr.termino_recurso_resultado_preliminar_avaliacao_pcd, 'YYYY-MM-DD') AS termino_recurso_resultado_preliminar_avaliacao_pcd,
    TO_CHAR(cr.inicio_recurso_ppni, 'YYYY-MM-DD') AS inicio_recurso_ppni,
    TO_CHAR(cr.termino_recurso_ppni, 'YYYY-MM-DD') AS termino_recurso_ppni,
    TO_CHAR(cr.resultado_final, 'YYYY-MM-DD') AS resultado_final,
  ep.selecao,
  ep.conteudo,
  ep.url_recurso,
  ep.mascara_inscricao,
  ep.edital,
  ep.descricao,
  ep.updated_at,
  COALESCE(
    (SELECT string_agg('<p class="mb-0 aviso-item">' || a.mensagem || '</p>', '<hr class="aviso-divider">' ORDER BY a.created_at DESC)
     FROM "sad-selecoes".avisos a
     WHERE a.id_selecao = cr.id_selecao AND a.ativo = true),
    ''
  ) AS avisos_html
FROM "sad-selecoes".cronograma cr
  JOIN "sad-selecoes".estrutura_html_portais ep
  ON ep.id_selecao = cr.id_selecao
WHERE cr.id_selecao = {{ $('direcionar portal').item.json.query.id }}
