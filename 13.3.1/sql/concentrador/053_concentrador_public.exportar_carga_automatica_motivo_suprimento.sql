DROP FUNCTION IF EXISTS public.exportar_carga_automatica_motivo_suprimento();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_motivo_suprimento()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT ms.id
       , ms.descricao
    FROM motivo_suprimento ms
   WHERE ms.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;