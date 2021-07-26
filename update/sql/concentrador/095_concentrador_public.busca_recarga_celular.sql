/*
 * Esta função realiza a busca de uma recarga de celular considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_recarga_celular;
CREATE OR REPLACE FUNCTION public.busca_recarga_celular(
	p_codigo INTEGER,
	p_id_sessao INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_recarga_celular INTEGER;
BEGIN
 SELECT id
 INTO   id_recarga_celular
 FROM   recargacelular
 WHERE  codigo = p_codigo
        AND idsessao = p_id_sessao;
 RETURN id_recarga_celular;
END;
$$  LANGUAGE plpgsql;

