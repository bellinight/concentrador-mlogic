DROP FUNCTION IF EXISTS public.exportar_carga_automatica_modalidade_frete();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_modalidade_frete()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , codigo_modalidade INTEGER
  , permite_desconto_frete BOOLEAN
  , compoe_base_icms BOOLEAN
  , compoe_base_pis_cofins BOOLEAN
)
AS $$
BEGIN
  RETURN QUERY
  SELECT mf.id
       , mf.descricao
       , mf.codigo_modalidade
       , mf.permite_desconto_frete
       , mf.compoe_base_icms
       , mf.compoe_base_pis_cofins
    FROM modalidade_frete mf
   WHERE mf.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;