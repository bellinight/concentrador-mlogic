/*
 * Esta função realiza a busca do caixa considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_caixa;
CREATE OR REPLACE FUNCTION public.busca_caixa(
        p_nun_loja INTEGER,
        p_id_pdv INTEGER,
        p_codigo INTEGER,
        p_data TIMESTAMP)
RETURNS INTEGER AS $$
DECLARE id_caixa INTEGER;
BEGIN
 SELECT id
 INTO   id_caixa
 FROM   caixa
 WHERE  numeroloja = p_nun_loja
	AND idpdv = p_id_pdv
	AND codigo = p_codigo
	AND data = p_data; 
 RETURN id_caixa;
END;
$$  LANGUAGE plpgsql;

