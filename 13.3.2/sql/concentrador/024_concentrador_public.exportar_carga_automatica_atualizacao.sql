DROP FUNCTION IF EXISTS public.exportar_carga_automatica_atualizacao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_atualizacao()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , sequencia INTEGER
  , tipo VARCHAR
  , data DATE
)
AS $$ 
BEGIN
  RETURN QUERY
  SELECT DISTINCT * FROM (
   (SELECT atualizacao.id
         , atualizacao.descricao
         , atualizacao.sequencia
         , atualizacao.tipo
         , atualizacao.data
      FROM atualizacao
     INNER JOIN pdv ON pdv.atualizacao = atualizacao.id
     ORDER BY atualizacao.id DESC
   ) UNION (
    SELECT atualizacao.id
         , atualizacao.descricao
         , atualizacao.sequencia
         , atualizacao.tipo
         , atualizacao.data
      FROM atualizacao
     ORDER BY atualizacao.id DESC LIMIT 30
   )
) AS tb ORDER BY tb.id DESC;
END;
$$  LANGUAGE plpgsql;