/*
 * Para a execução desta function é necessário rodar a function "public.preparar_carga_automatica" 
 * para inclusão dos dados na tabela temporária.
 */
DROP FUNCTION IF EXISTS public.exportar_carga_automatica_item_promocao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_item_promocao()
RETURNS TABLE (
    id INTEGER
  , id_promocao INTEGER
  , id_item INTEGER
  , prc_promo DECIMAL(18,4)
  , desconto DECIMAL(18,4)
  , qtde_promocional DECIMAL(18,4)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT temp.id
       , temp.id_promocao
       , temp.id_item
       , temp.prc_promo
       , temp.desconto
       , temp.qtde_promocional
    FROM tempDadosPromocao temp
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;
