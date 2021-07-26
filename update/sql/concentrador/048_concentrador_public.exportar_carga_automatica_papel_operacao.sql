DROP FUNCTION IF EXISTS public.exportar_carga_automatica_papel_operacao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_papel_operacao()
RETURNS TABLE (
    id INTEGER
  , idpapel INTEGER
  , idoperacao INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT po.id
       , po.idpapel
       , po.idoperacao
    FROM papeloperacao po
   WHERE po.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;