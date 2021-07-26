----------------------------------------------------------
-- Esta função realiza a gravação dos dados da Item Pré-Venda. --
----------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_item_pre_venda;
CREATE OR REPLACE FUNCTION public.persiste_item_pre_venda
	(p_ccf               	 INTEGER
	,p_serie             	 VARCHAR
	,p_coo               	 INTEGER
	,p_cod_pedido_venda		 INTEGER
	,p_id_item             	 INTEGER
	,p_preco             	 NUMERIC(18,4)
	,p_quantidade          	 NUMERIC(18,4)
	,p_valor_total	         NUMERIC(18,4) 
    ,p_valor_desconto		 NUMERIC(18,4)
    ,p_valor_liquido	     NUMERIC(18,4))
 RETURNS void AS $$

DECLARE 
  id_pre_venda_conc INTEGER;
  id_cupom INTEGER;
	
BEGIN
  id_cupom = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom > 0) 
  THEN
    id_pre_venda_conc = busca_pre_venda(id_cupom, p_cod_pedido_venda);
    IF (id_pre_venda_conc > 0) 
    THEN
      INSERT INTO item_pre_venda 
        (id_pre_venda
        ,id_item
        ,preco
        ,quantidade
        ,valor_total
        ,valor_desconto
        ,valor_liquido) 
      VALUES	
	    (id_pre_venda_conc
        ,p_id_item
        ,p_preco
        ,p_quantidade
        ,p_valor_total
        ,p_valor_desconto
        ,p_valor_liquido);
    END IF;
  END IF;
END;
$$  LANGUAGE plpgsql;