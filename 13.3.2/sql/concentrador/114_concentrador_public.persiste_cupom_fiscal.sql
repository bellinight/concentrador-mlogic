/*
 * Esta função realiza a gravação dos dados do cupom fiscal.
 */
DROP FUNCTION IF EXISTS public.persiste_cupom_fiscal; 
CREATE OR REPLACE FUNCTION public.persiste_cupom_fiscal(
	p_id_cliente INTEGER,
        p_id_sessao INTEGER,
        p_codigo INTEGER,
        p_data_abertura TIMESTAMP,
        p_data_fechamento TIMESTAMP,
        p_fechado BOOLEAN,
        p_cancelado BOOLEAN,
        p_totalizado BOOLEAN,
        p_coo INTEGER,
        p_ccf INTEGER,
        p_serie_ecf TEXT,
        p_desconto NUMERIC(18,4),
        p_acrescimo NUMERIC(18,4),
        p_modificado BOOLEAN,
        p_total_liquido NUMERIC(18,4),
        p_numero_loja_sessao INTEGER,
        p_id_pdv_sessao INTEGER,
        p_abertura_sessao TIMESTAMP,
        p_id_motivo_cancelamento INTEGER,
		p_troco NUMERIC(18,4),
		p_frete NUMERIC(18,4),
		p_id_supervisor_cancelamento INTEGER)	
RETURNS void AS $$
DECLARE id_cupom INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_cupom = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);  		 
 IF (id_cupom > 0) THEN
	UPDATE cupomfiscal
	   SET idcliente = p_id_cliente,
	       fechado = p_fechado,
	       cancelado = p_cancelado,
	       totalizado = p_totalizado,
	       totalliquido = p_total_liquido,
	       datafechamento = p_data_fechamento,
	       id_motivo_cancelamento = p_id_motivo_cancelamento,
		   troco = p_troco,
		   frete = p_frete,
	       md5_r04 = md5('pi'),
		   id_supervisor_cancelamento = p_id_supervisor_cancelamento
	WHERE  ccf = p_ccf
	  AND serieecf = p_serie_ecf;
 ELSE
	id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
	INSERT INTO cupomfiscal
	  (idcliente,
	  idsessao,
	  codigo,
	  dataabertura,
	  datafechamento,
	  fechado,
	  cancelado,
	  totalizado,
	  coo,
	  ccf,
	  serieecf,
	  desconto,
	  acrescimo,
	  modificado,
	  totalliquido,
	  id_motivo_cancelamento,
	  troco,
	  frete,
	  md5_r04,
	  id_supervisor_cancelamento)
	VALUES (p_id_cliente,
	  id_sessao,
	  p_codigo,
	  p_data_abertura,
	  p_data_fechamento,
	  p_fechado,
	  p_cancelado,
	  p_totalizado,
	  p_coo,
	  p_ccf,
	  p_serie_ecf,
	  p_desconto,
	  p_acrescimo,
	  p_modificado,
	  p_total_liquido,
	  p_id_motivo_cancelamento,
	  p_troco,
	  p_frete,
	  md5('pi'),
	  p_id_supervisor_cancelamento);
 END IF;
END;
$$  LANGUAGE plpgsql;