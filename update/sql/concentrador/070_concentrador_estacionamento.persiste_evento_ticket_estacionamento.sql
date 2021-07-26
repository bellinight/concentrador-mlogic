/*
 * Esta função realiza a gravação dos dados do evento ticket de estacionamento.
 */
 CREATE OR REPLACE FUNCTION estacionamento.persiste_evento_ticket_estacionamento(
	p_id_ticket INTEGER, 
    p_tipo_retorno CHARACTER VARYING, 
    p_decricao_retorno CHARACTER VARYING, 
    p_url TEXT, 
    p_xml_retorno TEXT, 
    p_valor_total NUMERIC, 
    p_valor_a_pagar NUMERIC, 
    p_valor_pre_validado NUMERIC, 
    p_tempo_pre_validado INTEGER, 
    p_nome_setor CHARACTER VARYING)
  RETURNS void AS $$

DECLARE id_evento_ticket INTEGER;
BEGIN
 id_evento_ticket = estacionamento.busca_evento_ticket_estacionamento(p_id_ticket);                 
 IF (id_evento_ticket IS NULL) THEN
    
  INSERT INTO estacionamento.evento_ticket
   (id_ticket, 
    tipo_retorno, 
    decricao_retorno, 
    url, 
    xml_retorno, 
    valor_total, 
    valor_a_pagar, 
    valor_pre_validado, 
    tempo_pre_validado, 
    nome_setor,
    desativado,
    modificado)
  VALUES (p_id_ticket, 
    p_tipo_retorno, 
    p_decricao_retorno, 
    p_url, 
    p_xml_retorno, 
    p_valor_total, 
    p_valor_a_pagar, 
    p_valor_pre_validado, 
    p_tempo_pre_validado, 
    p_nome_setor,
    null,
	true);
 END IF;
END;
$$ LANGUAGE plpgsql;