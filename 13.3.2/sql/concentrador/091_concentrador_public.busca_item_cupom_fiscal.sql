/*
 * Esta função realiza a busca de um item de cupom fiscal considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_item_cupom_fiscal;
CREATE OR REPLACE FUNCTION public.busca_item_cupom_fiscal(
	p_codigo INTEGER,
	p_ccf INTEGER,
	p_serie_ecf TEXT,
  p_coo INTEGER)
RETURNS INTEGER AS $$

DECLARE id_item_cupom INTEGER;
DECLARE id_cupom_fiscal INTEGER;
BEGIN
 id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
 SELECT itemcupomfiscal.id
 INTO   id_item_cupom
 FROM   itemcupomfiscal
 WHERE  itemcupomfiscal.codigo = p_codigo
       AND itemcupomfiscal.idcupomfiscal = id_cupom_fiscal;
 RETURN id_item_cupom;
END;
$$  LANGUAGE plpgsql;

