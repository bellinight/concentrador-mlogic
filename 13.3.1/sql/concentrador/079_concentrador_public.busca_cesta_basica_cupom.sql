/*
 * Esta função realiza a busca de uma cesta basica considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_cesta_basica_cupom;
CREATE OR REPLACE FUNCTION public.busca_cesta_basica_cupom(
	p_ccf INTEGER,
	p_serie_ecf TEXT,
	p_codigo INTEGER,
  p_coo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_cesta_basica INTEGER;
DECLARE id_cupom_fiscal INTEGER;
BEGIN
 id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
 SELECT id
 INTO   id_cesta_basica
 FROM   cestabasicacupom
 WHERE  cestabasicacupom.codigo = p_codigo
       AND cestabasicacupom.idcupomfiscal = id_cupom_fiscal;
 RETURN id_cesta_basica;
END;
$$  LANGUAGE plpgsql;

