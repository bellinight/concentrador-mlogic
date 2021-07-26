/*
 * Para a execução desta function é necessário rodar a function "public.preparar_carga_automatica" 
 * para inclusão dos dados na tabela temporária.
 */
DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promocao_a_partir_de();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promocao_a_partir_de()
RETURNS TABLE (
    id_promocao INTEGER
  , item_principal INTEGER
  , id_item_secundario INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT
         tp.id AS id_promocao
       , dp.id_item AS item_principal
       , ip.id_item_secundario
    FROM tempdadospromocao dp
    JOIN itempromocaolevepague ip
      ON ip.id_item_principal = dp.id_item
    JOIN temppromocao tp
      ON tp.id = dp.id_promocao
   WHERE ip.desativado IS NULL AND tp.id_modalidade = 3
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;
