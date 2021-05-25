----------------------------------------------------------
-- Esta função realiza a gravação dos dados da Pré-Venda. --
----------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_pre_venda;
CREATE OR REPLACE FUNCTION public.persiste_pre_venda
	(p_ccf               	 INTEGER
	,p_serie             	 VARCHAR
	,p_coo               	 INTEGER
	,p_id_cliente	         INTEGER 
    ,p_cod_pedido_venda		 INTEGER
    ,p_data_venda		     TIMESTAMP
    ,p_cod_pdv				 INTEGER
    ,p_status        		 VARCHAR
	,p_consumidor_final		 BOOLEAN
    ,p_propagado			 BOOLEAN)
 RETURNS void AS $$

DECLARE 
  id_pre_venda_conc INTEGER;
  id_cupom INTEGER;
	
BEGIN
  id_cupom = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom > 0) 
  THEN
    id_pre_venda_conc = busca_pre_venda(id_cupom, p_cod_pedido_venda);
    IF (id_pre_venda_conc IS NULL) 
    THEN
      INSERT INTO pre_venda 
        (id_cupom_fiscal
        ,id_cliente
        ,cod_pedido_venda
        ,data_venda
        ,cod_pdv
        ,status
        ,consumidor_final
        ,propagado) 
      VALUES	
	    (id_cupom
        ,p_id_cliente
        ,p_cod_pedido_venda
        ,p_data_venda
        ,p_cod_pdv
        ,p_status
        ,p_consumidor_final
        ,p_propagado);
    END IF;
  END IF;
END;
$$  LANGUAGE plpgsql;