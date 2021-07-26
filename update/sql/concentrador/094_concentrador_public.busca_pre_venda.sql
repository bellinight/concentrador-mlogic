--depende de: public.pre_venda
-------------------------------------------------------
-- Realiza a busca de uma Pre-Venda no banco de dados.
-------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_pre_venda;
CREATE OR REPLACE FUNCTION public.busca_pre_venda(
   p_id_cupom_fiscal INTEGER
  ,p_cod_pedido_venda INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_pre_venda INTEGER;
BEGIN
  SELECT id
	 INTO  id_pre_venda 
	 FROM  pre_venda
		WHERE id_cupom_fiscal = p_id_cupom_fiscal
	 AND cod_pedido_venda = p_cod_pedido_venda;
	 RETURN id_pre_venda;
END;
$$  LANGUAGE plpgsql;