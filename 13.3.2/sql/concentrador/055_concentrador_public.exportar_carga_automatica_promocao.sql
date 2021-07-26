/*
 * Para a execução desta function  necessário rodar a function "public.preparar_carga_automatica" 
 * para inclusão dos dados na tabela temporária.
 */
DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promocao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promocao()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , data_inicio TIMESTAMP
  , data_fim TIMESTAMP
  , id_modalidade INTEGER
  , id_retaguarda BIGINT
)
AS $$
BEGIN
  RETURN QUERY
  SELECT temp.id
       , temp.descricao
       , temp.data_inicio
       , temp.data_fim
       , temp.id_modalidade
       , temp.id_retaguarda
   FROM tempPromocao temp
  ORDER BY 1;
END;
$$  LANGUAGE plpgsql;
