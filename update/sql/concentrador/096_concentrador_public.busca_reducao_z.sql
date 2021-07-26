/*
 * Esta função realiza a busca de uma redução Z considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_reducao_z;
CREATE OR REPLACE FUNCTION public.busca_reducao_z(
	p_id_informacoes_ecf INTEGER,
	p_data_movimento DATE DEFAULT null) 
RETURNS INTEGER AS $$

DECLARE id_reducao_z INTEGER;
BEGIN
 SELECT id
 INTO   id_reducao_z
 FROM   reducaoz
 WHERE  idinformacoesecf = p_id_informacoes_ecf
 AND	datamovimento = p_data_movimento;
 RETURN id_reducao_z;
END;
$$  LANGUAGE plpgsql;

