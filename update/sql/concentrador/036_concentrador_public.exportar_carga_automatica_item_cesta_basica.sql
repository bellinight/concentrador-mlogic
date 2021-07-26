DROP FUNCTION IF EXISTS public.exportar_carga_automatica_item_cesta_basica();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_item_cesta_basica()
RETURNS TABLE (
    id INTEGER
  , iditem INTEGER
  , iditemcesta INTEGER
  , preco DECIMAL(18,4)
  , quantidade DECIMAL(18,4)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT icb.id
       , icb.iditem
       , icb.iditemcesta
       , icb.preco
       , icb.quantidade
    FROM itenscestabasica icb
   WHERE icb.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;