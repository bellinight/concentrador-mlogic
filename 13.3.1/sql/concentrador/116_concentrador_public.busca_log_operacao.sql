/*
 * Esta função realiza a busca de log operação considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_log_operacao;
CREATE OR REPLACE FUNCTION public.busca_log_operacao(
	p_data_movimento TIMESTAMP,
        p_id_informacoes_ecf INTEGER)
RETURNS INTEGER AS $$
DECLARE id_log_operacao INTEGER;
BEGIN
 SELECT id
 INTO   id_log_operacao
 FROM   logoperacao
 WHERE  datamovimento = p_data_movimento
	AND idecf = p_id_informacoes_ecf;
 RETURN id_log_operacao;
END;
$$  LANGUAGE plpgsql;

