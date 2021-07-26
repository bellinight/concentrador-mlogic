/*
 * Esta função realiza a busca de um correspondente bancário considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_correspondente_bancario;
CREATE OR REPLACE FUNCTION public.busca_correspondente_bancario(
	p_id_sessao INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_correspondente_bancario INTEGER;
BEGIN
 SELECT id
 INTO   id_correspondente_bancario
 FROM   correspondentebancario
 WHERE  idsessao = p_id_sessao
        AND codigo = p_codigo;  
RETURN id_correspondente_bancario;
END;
$$  LANGUAGE plpgsql;

