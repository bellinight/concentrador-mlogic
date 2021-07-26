DROP FUNCTION IF EXISTS public.exportar_carga_automatica_motivo_desconto();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_motivo_desconto()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT md.id
       , md.descricao
    FROM motivo_desconto md
   WHERE md.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;