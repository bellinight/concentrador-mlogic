/*
 * Esta função realiza a gravação dos dados do log de operação.
 *
 * select persiste_log_operacao('2013-09-09 01:00:00', 'teste', 1, 1, 1, 1)
 */ 
DROP FUNCTION IF EXISTS public.persiste_log_operacao;
CREATE OR REPLACE FUNCTION public.persiste_log_operacao(
	p_data_movimento TIMESTAMP,
	p_descricao TEXT, 
	p_id_fiscal INTEGER,
	p_id_operador INTEGER,
	p_id_informacoes_ecf INTEGER,
	p_id_operacao INTEGER) 
RETURNS void AS $$

DECLARE id_log_operacao INTEGER;
BEGIN
 id_log_operacao = busca_log_operacao(p_data_movimento, p_id_informacoes_ecf);                 
 IF (id_log_operacao IS NULL) THEN
    
  INSERT INTO logoperacao
   (datamovimento,
   descricao,
   idfiscal,
   idoperador,
   idecf,
   idoperacao,
   modificado,
   desativado)
  VALUES (p_data_movimento,
   p_descricao,
   p_id_fiscal,
   p_id_operador,
   p_id_informacoes_ecf,
   p_id_operacao,
   true,
   null);
 ELSE
  UPDATE logoperacao
  SET datamovimento = p_data_movimento, descricao = p_descricao, idfiscal = p_id_fiscal, idoperador = p_id_operador, 
      idecf = p_id_informacoes_ecf, idoperacao = p_id_operacao, modificado = true, desativado = null
  WHERE id = id_log_operacao;
 END IF;
END;
$$  LANGUAGE plpgsql;

