/*
 * Esta função realiza a busca do evento ticket de estacionamento considerando os parâmetros passados.
 */
CREATE OR REPLACE FUNCTION estacionamento.busca_evento_ticket_estacionamento(
	p_id_ticket INTEGER)
  RETURNS INTEGER AS $$
DECLARE id_evento_ticket INTEGER;
BEGIN
 SELECT id
 INTO   id_evento_ticket
 FROM   estacionamento.evento_ticket
 WHERE  id_ticket = p_id_ticket;
 RETURN id_evento_ticket;
END;
$$ LANGUAGE plpgsql;
