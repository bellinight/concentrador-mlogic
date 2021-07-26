DROP FUNCTION IF EXISTS exportar_carga_automatica_unidade();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_unidade()
RETURNS TABLE (
    id INTEGER
  , sigla VARCHAR
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT u.id
       , u.sigla
       , u.desativado
    FROM unidade u
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;