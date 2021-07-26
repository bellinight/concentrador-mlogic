/*
 * Esta função realiza a busca do ticket de estacionamento considerando os parâmetros passados.
 */
CREATE OR REPLACE FUNCTION estacionamento.busca_ticket_estacionamento(
	p_id_item_cupom_fiscal INTEGER, 
	p_numero_ticket CHARACTER VARYING)
  RETURNS INTEGER AS $$
DECLARE id_ticket INTEGER;
BEGIN
 SELECT id
 INTO   id_ticket
 FROM   estacionamento.ticket
 WHERE  id_item_cupom_fiscal = p_id_item_cupom_fiscal
	AND numero_ticket = p_numero_ticket;
 RETURN id_ticket;
END;
$$ LANGUAGE plpgsql;
