/*
 * Esta função realiza a busca de uma sessão considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_sessao;
CREATE OR REPLACE FUNCTION public.busca_sessao(
	p_numero_loja INTEGER,
	p_id_pdv INTEGER,
	p_codigo INTEGER, 
	p_abertura TIMESTAMP)
RETURNS INTEGER AS $$

DECLARE id_sessao INTEGER;
BEGIN
	 SELECT id
	 INTO   id_sessao
	 FROM   sessao
	 WHERE  numeroloja = p_numero_loja
	       AND idpdv = p_id_pdv
	       AND codigo = p_codigo
	       AND abertura = p_abertura;
	 RETURN id_sessao;
END;
$$  LANGUAGE plpgsql;

