DROP FUNCTION IF EXISTS public.busca_item_cupom_desconto;
CREATE OR REPLACE FUNCTION public.busca_item_cupom_desconto(
       p_codigo INTEGER
     , p_id_cupom INTEGER
     , p_indice_item INTEGER)
RETURNS INTEGER AS $$

DECLARE id_item_cupom_desconto INTEGER;
BEGIN
  SELECT id
    INTO id_item_cupom_desconto
    FROM item_cupom_desconto
   WHERE codigo = p_codigo
     AND id_cupom = p_id_cupom
     AND indice_item = p_indice_item;
  RETURN id_item_cupom_desconto;
END;
$$  LANGUAGE plpgsql;

