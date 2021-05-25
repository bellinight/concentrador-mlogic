DROP FUNCTION IF EXISTS public.exportar_carga_automatica_juros();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_juros()
RETURNS TABLE (
    id INTEGER
  , dias INTEGER
  , taxa DECIMAL(18,4)
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT j.id
       , j.dias
       , j.taxa
       , j.desativado 
    FROM juros j
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;