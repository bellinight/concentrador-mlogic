DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promo_camp_grupo_de_venda();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promo_camp_grupo_de_venda()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT promo_grupo_venda.id
       , promo_grupo_venda.descricao
    FROM promo_camp_grupo_de_venda promo_grupo_venda
   WHERE promo_grupo_venda.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;