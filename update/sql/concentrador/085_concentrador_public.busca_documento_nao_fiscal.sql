/*
 * Esta função realiza a busca do documento não fiscal considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_documento_nao_fiscal;
CREATE OR REPLACE FUNCTION public.busca_documento_nao_fiscal(
	p_id_informacoes_ecf INTEGER,
	p_id_sessao INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_documento_nao_fiscal INTEGER;
BEGIN
 SELECT id
 INTO   id_documento_nao_fiscal
 FROM   documentonaofiscal
 WHERE  idinformacoesecf = p_id_informacoes_ecf
        AND idsessao = p_id_sessao
        AND codigo = p_codigo;  
 RETURN id_documento_nao_fiscal;
END;
$$  LANGUAGE plpgsql;

