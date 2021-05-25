/*
 * Esta função realiza a busca de um bloqueio sessao considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_bloqueio_sessao;
CREATE OR REPLACE FUNCTION public.busca_bloqueio_sessao(
	p_id_sessao INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_bloqueio_sessao INTEGER;
BEGIN
 SELECT id
 INTO   id_bloqueio_sessao
 FROM   bloqueiosessao
 WHERE  idsessao = p_id_sessao
        AND codigo = p_codigo;  
 RETURN id_bloqueio_sessao;
END;
$$  LANGUAGE plpgsql;

