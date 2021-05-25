DROP FUNCTION IF EXISTS public.exportar_carga_automatica_informacao_ecf();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_informacao_ecf()
RETURNS TABLE (
    id INTEGER
  , numerofabricacao VARCHAR
  , memoriafiscaladicional VARCHAR
  , tipo VARCHAR
  , marca VARCHAR
  , modelo VARCHAR
  , versaosoftwarebasico VARCHAR
  , instalacaosoftwarebasic TIMESTAMP
  , numerosequencial INTEGER
  , codigonacionalindentificacao VARCHAR
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT e.id
       , e.numerofabricacao
       , e.memoriafiscaladicional
       , e.tipo
       , e.marca
       , e.modelo
       , e.versaosoftwarebasico
       , e.instalacaosoftwarebasic
       , e.numerosequencial
       , e.codigonacionalindentificacao
       , e.desativado
   FROM ecf e
  ORDER BY 1;
END;
$$  LANGUAGE plpgsql;