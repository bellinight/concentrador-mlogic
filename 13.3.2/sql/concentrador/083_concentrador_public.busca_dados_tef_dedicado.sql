/*
 * Esta função realiza a busca dos dados TEF Dedicado considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_dados_tef_dedicado;
CREATE OR REPLACE FUNCTION public.busca_dados_tef_dedicado(
	p_id_sessao INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_dados_tef_dedicado INTEGER;
BEGIN
 SELECT id
 INTO   id_dados_tef_dedicado
 FROM   dadostefdedicado
 WHERE  codigo = p_codigo
        AND idsessao = p_id_sessao;
 RETURN id_dados_tef_dedicado;
END;
$$  LANGUAGE plpgsql;

