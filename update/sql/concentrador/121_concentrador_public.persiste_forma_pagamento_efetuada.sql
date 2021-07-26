/*
 * Esta função realiza a gravação dos dados da forma de pagamento efetuada.
 */
DROP FUNCTION IF EXISTS public.persiste_forma_pagamento_efetuada; 
CREATE OR REPLACE FUNCTION public.persiste_forma_pagamento_efetuada(
	p_id_forma INTEGER,
	p_id_sessao INTEGER,
	p_id_forma_estorno INTEGER,
	p_codigo INTEGER,
	p_valor DECIMAL(18,4),
	p_modificado BOOLEAN,
	p_ccf_cupom INTEGER,
	p_serie_ecf_cupom TEXT,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
  p_id_cliente INTEGER,
  p_coo_cupom INTEGER,
  p_valor_recebido DECIMAL(18,4),
  p_codigo_convenio INTEGER,
  p_codigo_conveniado INTEGER) 
RETURNS void AS $$

DECLARE id_forma INTEGER;
DECLARE id_cupom INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_cupom = busca_cupom_fiscal(p_ccf_cupom, p_serie_ecf_cupom, p_coo_cupom);  	
 id_forma = busca_forma_pagamento_efetuada(id_cupom, p_codigo);
                 
 IF (id_forma IS NULL) THEN
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  INSERT INTO formapagamentoefetuada
    (idforma,
    idcupom,
    idsessao,
    idformaestorno,
    codigo,
    valor,
    modificado, 
    md5_a2,
	  md5_h2,
	  md5_r07,
    idcliente,
    valor_recebido,
	codigo_convenio,
    codigo_conveniado)
  VALUES (p_id_forma,
    id_cupom,
    id_sessao,
    p_id_forma_estorno,
    p_codigo,
    p_valor,
    p_modificado,
    md5('pi'),
	md5('pi'),
	md5('pi'),
  p_id_cliente,
  p_valor_recebido,
  p_codigo_convenio,
  p_codigo_conveniado); 
 END IF;
END; 
$$  LANGUAGE plpgsql;

