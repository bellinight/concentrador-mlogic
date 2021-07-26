DROP FUNCTION IF EXISTS public.persiste_dados_tef_dedicado(integer, integer, integer, integer, integer, text, text, text, text, text, text, text, numeric, boolean, timestamp without time zone, boolean, integer, integer, timestamp without time zone, numeric, integer, text);
DROP FUNCTION IF EXISTS public.persiste_dados_tef_dedicado(integer, integer, integer, integer, integer, text, text, text, text, text, text, text, numeric, boolean, timestamp without time zone, boolean, integer, integer, timestamp without time zone, numeric, integer, text, text, text, text, text);
DROP FUNCTION IF EXISTS public.persiste_dados_tef_dedicado(integer, integer, integer, integer, integer, text, text, text, text, text, text, text, numeric, boolean, timestamp without time zone, boolean, integer, integer, timestamp without time zone, numeric, integer, text, text, text, text, text, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION public.persiste_dados_tef_dedicado (
       p_id_correspondente_bancario INTEGER
     , p_id_pagamento_tef INTEGER
     , p_id_recarga_celular INTEGER
     , p_id_sessao INTEGER
     , p_codigo INTEGER
     , p_primeira_via_comprovante TEXT
     , p_segunda_via_comprovante TEXT
     , p_nsu_sitef TEXT
     , p_nsu_host_autorizador TEXT
     , p_forma_pagamento TEXT
     , p_condicao_pagamento TEXT
     , p_descricao_modalidade TEXT
     , p_valor_documento NUMERIC
     , p_modificado BOOLEAN
     , p_data_hora_transacao TIMESTAMP WITHOUT TIME ZONE
     , p_confirmado BOOLEAN
     , p_numero_loja_sessao INTEGER
     , p_id_pdv_sessao INTEGER
     , p_abertura_sessao TIMESTAMP WITHOUT TIME ZONE
     , p_saque NUMERIC
     , p_numero_parcelas INTEGER
     , p_codigo_autorizacao TEXT
     , p_bin TEXT
     , p_codigo_estabelecimento TEXT
     , p_rede TEXT
     , p_bandeira TEXT
     , p_codigo_ident_carteira_digital VARCHAR
     , p_descricao_carteira_digital VARCHAR
     , p_codigo_psp_carteira_digital VARCHAR
 )
RETURNS void AS $$

DECLARE id_dados_tef_dedicado INTEGER;
DECLARE id_sessao INTEGER;
DECLARE id_pagamento_tef INTEGER;
DECLARE id_recarga_celular INTEGER;
DECLARE id_correspondente_bancario INTEGER;
BEGIN
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  id_dados_tef_dedicado = busca_dados_tef_dedicado(id_sessao, p_codigo);

  id_pagamento_tef = busca_pagamento_tef(id_sessao, p_id_pagamento_tef);
  id_recarga_celular = busca_recarga_celular(p_id_recarga_celular, id_sessao);
  id_correspondente_bancario = busca_correspondente_bancario(id_sessao, p_id_correspondente_bancario);
  
  IF (id_pagamento_tef IS NULL AND id_recarga_celular IS NULL AND id_correspondente_bancario IS NULL)
  THEN
    RAISE EXCEPTION 'Nenhum pagamento, recarga ou corresp. bancário encontrado.';
  END IF;

  IF (id_dados_tef_dedicado IS NULL)
  THEN 
    INSERT INTO dadostefdedicado (
           idcorrespondentebancario
         , idpagamentotef
         , idrecargacelular
         , idsessao
         , codigo
         , primeiraviacomprovante
         , segundaviacomprovante
         , nsusitef
         , nsuhostautorizador
         , formapagamento
         , condicaopagamento
         , descricaomodalidade
         , valordocumento
         , modificado
         , datahoratransacao
         , confirmado
         , saque
         , numeroparcelas
         , codigoautorizacao
         , bin
         , codigo_estabelecimento
         , rede
         , bandeira
         , codigo_ident_carteira_digital
         , descricao_carteira_digital
         , codigo_psp_carteira_digital
    ) VALUES (
           id_correspondente_bancario
         , id_pagamento_tef
         , id_recarga_celular
         , id_sessao
         , p_codigo
         , p_primeira_via_comprovante
         , p_segunda_via_comprovante
         , p_nsu_sitef
         , p_nsu_host_autorizador
         , p_forma_pagamento
         , p_condicao_pagamento
         , p_descricao_modalidade
         , p_valor_documento
         , p_modificado
         , p_data_hora_transacao
         , p_confirmado
         , p_saque
         , p_numero_parcelas
         , p_codigo_autorizacao
         , p_bin
         , p_codigo_estabelecimento
         , p_rede
         , p_bandeira
         , p_codigo_ident_carteira_digital
         , p_descricao_carteira_digital
         , p_codigo_psp_carteira_digital
    );
  ELSE
    UPDATE dadostefdedicado
       SET idcorrespondentebancario = id_correspondente_bancario
         , idpagamentotef = id_pagamento_tef
         , idrecargacelular = id_recarga_celular
         , idsessao = id_sessao
         , codigo = p_codigo
         , primeiraviacomprovante = p_primeira_via_comprovante
         , segundaviacomprovante = p_segunda_via_comprovante
         , nsusitef = p_nsu_sitef
         , nsuhostautorizador = p_nsu_host_autorizador
         , formapagamento = p_forma_pagamento
         , condicaopagamento = p_condicao_pagamento
         , descricaomodalidade = p_descricao_modalidade
         , valordocumento = p_valor_documento
         , modificado = p_modificado
         , datahoratransacao = p_data_hora_transacao
         , confirmado = p_confirmado
         , saque = p_saque
         , numeroparcelas = p_numero_parcelas
         , codigoautorizacao = p_codigo_autorizacao
         , bin = p_bin
         , codigo_estabelecimento = p_codigo_estabelecimento
         , rede = p_rede
         , bandeira = p_bandeira
         , codigo_ident_carteira_digital = p_codigo_ident_carteira_digital
         , descricao_carteira_digital = p_descricao_carteira_digital
         , codigo_psp_carteira_digital = p_codigo_psp_carteira_digital
     WHERE id = id_dados_tef_dedicado;
  END IF;
END;
$$ LANGUAGE plpgsql;

