/*
 * Esta função realiza a busca de um cupom fiscal considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_cupom_fiscal;
CREATE OR REPLACE FUNCTION public.busca_cupom_fiscal(
       p_ccf INTEGER
     , p_serie_ecf TEXT
     , p_coo INTEGER)
RETURNS INTEGER AS $$

DECLARE id_cupom INTEGER;
BEGIN
  SELECT id
    INTO id_cupom
    FROM cupomfiscal
   WHERE ccf = p_ccf
     AND serieecf = p_serie_ecf
     AND coo = p_coo;
  RETURN id_cupom;
END;
$$  LANGUAGE plpgsql;

