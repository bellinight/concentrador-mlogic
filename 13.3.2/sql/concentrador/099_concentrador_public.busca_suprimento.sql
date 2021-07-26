/*
 * Esta função realiza a busca de um suprimento considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_suprimento;
CREATE OR REPLACE FUNCTION public.busca_suprimento(
	p_id_informacoes_ecf INTEGER,
	p_coo INTEGER,
  p_gnf INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_suprimento INTEGER;
BEGIN
 SELECT id
 INTO   id_suprimento
 FROM   suprimento
 WHERE  idinformacoesecf = p_id_informacoes_ecf
        AND coo = p_coo
        AND gnf = p_gnf;
 RETURN id_suprimento;
END;
$$  LANGUAGE plpgsql;

