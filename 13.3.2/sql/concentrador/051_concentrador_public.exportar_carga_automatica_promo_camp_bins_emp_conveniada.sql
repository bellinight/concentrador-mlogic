DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promo_camp_bins_emp_conveniada();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promo_camp_bins_emp_conveniada()
RETURNS TABLE (
    id_empresa_conveniada INTEGER
  , bin INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT prom_bin.id_empresa_conveniada
       , prom_bin.bin
    FROM promo_camp_bins_emp_conveniada prom_bin
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;