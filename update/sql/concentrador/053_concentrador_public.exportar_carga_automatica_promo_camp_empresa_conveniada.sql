DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promo_camp_empresa_conveniada();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promo_camp_empresa_conveniada()
RETURNS TABLE (
    id INTEGER
     , descricao VARCHAR
     , rede VARCHAR
     , bandeira VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT promo_camp.id
       , promo_camp.descricao
       , promo_camp.rede
       , promo_camp.bandeira
    FROM promo_camp_empresa_conveniada promo_camp
   WHERE promo_camp.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;