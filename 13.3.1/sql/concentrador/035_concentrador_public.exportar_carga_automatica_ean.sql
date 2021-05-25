DROP FUNCTION IF EXISTS public.exportar_carga_automatica_ean();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_ean()
RETURNS TABLE (
    id INTEGER
  , ean VARCHAR
  , iditem INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT e.id
       , e.ean
       , e.iditem
    FROM ean e
   WHERE e.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;