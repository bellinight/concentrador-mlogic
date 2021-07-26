DROP FUNCTION IF EXISTS exportar_carga_automatica_taxa_entrega();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_taxa_entrega()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , valor DECIMAL(18,4)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT te.id
       , te.descricao
       , te.valor
    FROM taxa_entrega te
   WHERE desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;