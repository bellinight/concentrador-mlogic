DROP FUNCTION IF EXISTS public.exportar_carga_automatica_item_cliente_preferencial();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_item_cliente_preferencial()
RETURNS TABLE (
    id INTEGER
  , iditem INTEGER
  , desconto DECIMAL(18,4)
  , idcliente INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT icp.id
       , icp.iditem
       , icp.desconto
       , icp.idcliente
    FROM itemclientepreferencial icp
   WHERE icp.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;