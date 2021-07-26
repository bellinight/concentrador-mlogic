/*
 * Esta função realiza a gravação dos dados da sessao.
 */
DROP FUNCTION IF EXISTS public.persiste_sessao; 
CREATE OR REPLACE FUNCTION public.persiste_sessao(
	p_id_usuario INTEGER,
	p_id_pdv INTEGER,
	p_numero_loja INTEGER,
	p_codigo INTEGER,
	p_fechado BOOLEAN,
	p_abertura TIMESTAMP,
	p_modificado BOOLEAN,
	p_codigo_caixa INTEGER,
	p_data_caixa TIMESTAMP,
	p_fechamento TIMESTAMP DEFAULT NULL) 
RETURNS void AS $$

DECLARE id_sessao INTEGER;
DECLARE id_caixa INTEGER;
BEGIN
 id_sessao = busca_sessao(p_numero_loja, p_id_pdv, p_codigo, p_abertura);         
 IF (id_sessao > 0) THEN
	UPDATE sessao
	   SET fechamento = p_fechamento
	     , fechado = p_fechado
	 WHERE id = id_sessao;
 ELSE
	id_caixa = busca_caixa(p_numero_loja, p_id_pdv, p_codigo_caixa, p_data_caixa);
	INSERT INTO sessao
	  (idusuario,
	  idcaixa,
	  idpdv,
	  numeroloja,
	  codigo,
	  fechado,
	  abertura,
	  fechamento,
	  modificado)
	VALUES (p_id_usuario,
	  id_caixa,
	  p_id_pdv,
	  p_numero_loja,
	  p_codigo,
	  p_fechado,
	  p_abertura,
	  p_fechamento,
	  p_modificado);
 END IF;
END;
$$  LANGUAGE plpgsql;

