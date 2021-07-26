/*
 * Esta função realiza a gravação dos dados do ticket de estacionamento.
 */
 CREATE OR REPLACE FUNCTION estacionamento.persiste_ticket_estacionamento(
	p_id_item_cupom_fiscal INTEGER, 
	p_numero_ticket CHARACTER VARYING, 
	p_tempo_abono INTEGER, 
	p_valor_pagamento NUMERIC, 
	p_data_hora_pagamento TIMESTAMP WITHOUT TIME ZONE, 
	p_tarifa INTEGER, 
	p_numero_abono CHARACTER VARYING, 
	p_tempo_adiantamento INTEGER, 
	p_data_entrada TIMESTAMP WITHOUT TIME ZONE,
	p_codigo_barras_selo CHARACTER VARYING)
  RETURNS void AS $$

DECLARE id_ticket INTEGER;
BEGIN
 id_ticket = estacionamento.busca_ticket_estacionamento(p_id_item_cupom_fiscal, p_numero_ticket);                 
 IF (id_ticket IS NULL) THEN
    
  INSERT INTO estacionamento.ticket
   (id_item_cupom_fiscal, 
    numero_ticket, 
    tempo_abono, 
    valor_pagamento, 
    data_hora_pagamento, 
    tarifa, 
    numero_abono, 
    tempo_adiantamento, 
    data_entrada, 
    codigo_barras_selo,
    desativado,
    modificado)
  VALUES (p_id_item_cupom_fiscal, 
    p_numero_ticket, 
    p_tempo_abono, 
    p_valor_pagamento, 
    p_data_hora_pagamento, 
    p_tarifa, 
    p_numero_abono, 
    p_tempo_adiantamento, 
    p_data_entrada, 
    p_codigo_barras_selo,
    null,
    true);
 END IF;
END;
$$ LANGUAGE plpgsql;
