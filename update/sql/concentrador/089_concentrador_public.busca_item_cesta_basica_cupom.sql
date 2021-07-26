/*
 * Esta função realiza a busca de um item de cesta basica cupom considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_item_cesta_basica_cupom;
CREATE OR REPLACE FUNCTION public.busca_item_cesta_basica_cupom(
	p_id_item_cupom_fiscal INTEGER,
	p_id_cesta_basica_cupom INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_item_cesta_basica INTEGER;
BEGIN
 SELECT id
 INTO   id_item_cesta_basica
 FROM   itemcestabasicacupom
 WHERE  iditemcupomfiscal = p_id_item_cupom_fiscal
        AND idcestabasicacupom = p_id_cesta_basica_cupom
        AND codigo = p_codigo; 
 RETURN id_item_cesta_basica;
END;
$$  LANGUAGE plpgsql;

