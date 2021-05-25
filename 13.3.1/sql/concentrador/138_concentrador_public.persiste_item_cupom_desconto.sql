DROP FUNCTION IF EXISTS public.persiste_item_cupom_desconto;
CREATE OR REPLACE FUNCTION public.persiste_item_cupom_desconto (
       p_codigo INTEGER
     , p_ccf INTEGER
     , p_serie TEXT
     , p_coo INTEGER
     , p_indice_item INTEGER
     , p_valor_desconto NUMERIC(18, 4)
     , p_id_modalidade INTEGER
     , p_quantidade_aplicada NUMERIC(18,4))
RETURNS void AS $$

DECLARE
  id_cupom_fiscal INTEGER;
  id_item_cupom_desconto INTEGER;
BEGIN
  id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom_fiscal > 0)
  THEN
    id_item_cupom_desconto = busca_item_cupom_desconto(p_codigo, id_cupom_fiscal, p_indice_item);
    IF (id_item_cupom_desconto IS NULL)
    THEN
    INSERT INTO item_cupom_desconto (
           codigo
         , serie
         , id_cupom
         , indice_item
         , valor_desconto
         , id_modalidade
         , quantidade_aplicada)
    VALUES (
           p_codigo
         , p_serie
         , id_cupom_fiscal
         , p_indice_item
         , p_valor_desconto
         , p_id_modalidade
         , p_quantidade_aplicada);
    END IF;
 END IF;
END;
$$  LANGUAGE plpgsql;