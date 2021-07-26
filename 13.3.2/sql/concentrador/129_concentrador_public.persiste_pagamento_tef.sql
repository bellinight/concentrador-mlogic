/*
 * Esta função realiza a gravação dos dados do pagamento TEF.
 */ 
DROP FUNCTION IF EXISTS public.persiste_pagamento_tef;
CREATE OR REPLACE FUNCTION public.persiste_pagamento_tef(
	p_id_forma_pagamento_efetuada INTEGER,
	p_id_sessao INTEGER,
	p_codigo INTEGER,
	p_cmc7 TEXT,
	p_data_vencimento TIMESTAMP,
	p_banco TEXT,
	p_agencia TEXT,
	p_conta_corrente TEXT,
	p_numero_cheque TEXT,
	p_telefone TEXT,
	p_autenticacao TEXT,
	p_rede TEXT,
	p_bandeira TEXT,
	p_valor_pagamento NUMERIC(18, 4),
	p_valor_juros NUMERIC(18, 4),
	p_modificado BOOLEAN,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
	p_ccf INTEGER,
	p_serie_ecf TEXT,
  p_coo INTEGER) 
RETURNS void AS $$

DECLARE id_pagamento_tef INTEGER;
DECLARE id_sessao INTEGER;
DECLARE id_forma_efetuada INTEGER;
DECLARE id_cupom_fiscal INTEGER;
BEGIN
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
 id_pagamento_tef = busca_pagamento_tef(id_sessao, p_codigo);      
 
 id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
 id_forma_efetuada = busca_forma_pagamento_efetuada(id_cupom_fiscal, p_id_forma_pagamento_efetuada);
 
 IF (id_pagamento_tef IS NULL) THEN
   INSERT INTO pagamentotef
    (idformapagamentoefetuada,
    idsessao,
    codigo,
    cmc7,
    datavencimento,
    banco,
    agencia,
    contacorrente,
    numerocheque,
    telefone,
    autenticacao,
    rede,
    bandeira,
    valorpagamento,
    valorjuros,
    modificado)
   VALUES (id_forma_efetuada,
    id_sessao,
    p_codigo,
    p_cmc7,
    p_data_vencimento,
    p_banco,
    p_agencia,
    p_conta_corrente,
    p_numero_cheque,
    p_telefone,
    p_autenticacao,
    p_rede,
    p_bandeira,
    p_valor_pagamento,
    p_valor_juros,
    p_modificado);
 ELSE
	UPDATE pagamentotef
	SET idformapagamentoefetuada = id_forma_efetuada, idsessao = id_sessao, codigo = p_codigo, cmc7 = p_cmc7, datavencimento = p_data_vencimento,
		banco = p_banco, agencia = p_agencia, contacorrente = p_conta_corrente,  numerocheque = p_numero_cheque, telefone = p_telefone, 
		autenticacao = p_autenticacao, rede = p_rede, bandeira = p_bandeira, valorpagamento = p_valor_pagamento, valorjuros = p_valor_juros, 
		modificado = p_modificado
	WHERE id = id_pagamento_tef;
 END IF;
END;
$$  LANGUAGE plpgsql;

