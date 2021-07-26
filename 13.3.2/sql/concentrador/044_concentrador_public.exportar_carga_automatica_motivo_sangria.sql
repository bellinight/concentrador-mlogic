DROP FUNCTION IF EXISTS public.exportar_carga_automatica_motivo_sangria();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_motivo_sangria()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , existe_envelope BOOLEAN
)
AS $$
BEGIN
  RETURN QUERY
  SELECT ms.id
       , ms.descricao
       , ms.existe_envelope
    FROM motivo_sangria ms
   WHERE ms.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;