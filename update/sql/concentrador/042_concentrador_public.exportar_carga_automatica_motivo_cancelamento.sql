DROP FUNCTION IF EXISTS public.exportar_carga_automatica_motivo_cancelamento();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_motivo_cancelamento()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT mc.id
       , mc.descricao
    FROM motivocancelamento mc
   WHERE mc.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;