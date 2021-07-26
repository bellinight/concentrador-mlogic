DROP FUNCTION IF EXISTS public.exportar_carga_automatica_item_producao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_item_producao()
RETURNS TABLE (
    id INTEGER
  , iditemprincipal INTEGER
  , iditemsecundario INTEGER
  , quantidade DECIMAL(18,4)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT ip.id
       , ip.iditemprincipal
       , ip.iditemsecundario
       , ip.quantidade
    FROM itemproducao ip
   WHERE ip.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;