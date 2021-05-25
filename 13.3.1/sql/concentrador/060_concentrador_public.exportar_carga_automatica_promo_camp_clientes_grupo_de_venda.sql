DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promo_camp_clientes_grupo_de_venda();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promo_camp_clientes_grupo_de_venda()
RETURNS TABLE (
    id_cliente INTEGER
  , id_grupo_de_venda INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT promo_cliente.id_cliente
       , promo_cliente.id_grupo_de_venda
    FROM promo_camp_clientes_grupo_de_venda promo_cliente
   WHERE promo_cliente.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;