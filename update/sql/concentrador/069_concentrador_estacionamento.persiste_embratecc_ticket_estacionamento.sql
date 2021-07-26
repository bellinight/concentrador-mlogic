/*
 * EMBRATECC
 * Esta função realiza a gravação dos dados do ticket de estacionamento.
 */
 CREATE OR REPLACE FUNCTION estacionamento.persiste_embratecc_ticket_estacionamento(
	p_ccf INTEGER,
  p_serie_ecf VARCHAR, 
  p_coo INTEGER, 
	p_tamanho_protocolo VARCHAR, 
	p_versao VARCHAR,
  p_numero_ticket VARCHAR,   
  p_codigo_resposta VARCHAR,
  p_descricao VARCHAR,
	p_data_hora_pagamento TIMESTAMP WITHOUT TIME ZONE)
  RETURNS void AS $$

DECLARE id_ticket INTEGER;
DECLARE v_id_cupom_fiscal INTEGER;
BEGIN
 v_id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
 IF (v_id_cupom_fiscal IS NOT NULL) THEN
     id_ticket = estacionamento.busca_embratecc_ticket_estacionamento(v_id_cupom_fiscal, p_numero_ticket);                 
     IF (id_ticket IS NULL) THEN
      INSERT INTO estacionamento.embratecc_ticket
       (id_cupom_fiscal, 
        tamanho_protocolo, 
        versao, 
        numero_ticket,
        codigo_resposta,  
        descricao, 
        data_hora_pagamento)
      VALUES (v_id_cupom_fiscal, 
        p_tamanho_protocolo, 
        p_versao, 
        p_numero_ticket,
        p_codigo_resposta,
        p_descricao, 
        p_data_hora_pagamento);
     END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;
