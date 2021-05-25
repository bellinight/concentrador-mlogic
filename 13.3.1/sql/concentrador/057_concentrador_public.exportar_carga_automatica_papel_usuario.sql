DROP FUNCTION IF EXISTS public.exportar_carga_automatica_papel_usuario();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_papel_usuario()
RETURNS TABLE (
    id INTEGER
  , idpapel INTEGER
  , idusuario INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT pu.id
       , pu.idpapel
       , pu.idusuario
    FROM papelusuario pu
   WHERE pu.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;