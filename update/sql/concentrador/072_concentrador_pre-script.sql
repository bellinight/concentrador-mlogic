DROP TRIGGER IF EXISTS atualizacao_estoquepafecf ON caixa;
DROP TRIGGER IF EXISTS ins_upd_pafecf_empresa ON empresa;
DROP TRIGGER IF EXISTS del_pafecf_empresa ON empresa;
DROP TRIGGER IF EXISTS ins_upd_pafecf_item ON item;
DROP TRIGGER IF EXISTS del_pafecf_item ON item;
DROP TRIGGER IF EXISTS ins_upd_pafecf_formapagamentoefetuada ON formapagamentoefetuada;
DROP TRIGGER IF EXISTS del_pafecf_formapagamentoefetuada ON formapagamentoefetuada;
DROP TRIGGER IF EXISTS ins_upd_pafecf_ecf ON ecf;
DROP TRIGGER IF EXISTS del_pafecf_ecf ON ecf;
DROP TRIGGER IF EXISTS ins_upd_pafecf_reducaoz ON reducaoz;
DROP TRIGGER IF EXISTS del_pafecf_reducaoz ON reducaoz;
DROP TRIGGER IF EXISTS ins_upd_pafecf_totalizadorparcialreducaoz ON totalizadorparcialreducaoz;
DROP TRIGGER IF EXISTS del_pafecf_totalizadorparcialreducaoz ON totalizadorparcialreducaoz;
DROP TRIGGER IF EXISTS ins_upd_pafecf_cupomfiscal ON cupomfiscal;
DROP TRIGGER IF EXISTS del_pafecf_cupomfiscal ON cupomfiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_itemcupomfiscal ON itemcupomfiscal;
DROP TRIGGER IF EXISTS del_pafecf_itemcupomfiscal ON itemcupomfiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_suprimento ON suprimento;
DROP TRIGGER IF EXISTS del_pafecf_suprimento ON suprimento;
DROP TRIGGER IF EXISTS ins_upd_pafecf_sangriaefetuada ON sangriaefetuada;
DROP TRIGGER IF EXISTS del_pafecf_sangriaefetuada ON sangriaefetuada;
DROP TRIGGER IF EXISTS ins_upd_pafecf_comprovantenaofiscal ON comprovantenaofiscal;
DROP TRIGGER IF EXISTS del_pafecf_comprovantenaofiscal ON comprovantenaofiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_documentonaofiscal ON documentonaofiscal;
DROP TRIGGER IF EXISTS del_pafecf_documentonaofiscal ON documentonaofiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_notafiscal ON notafiscal;
DROP TRIGGER IF EXISTS del_pafecf_notafiscal ON notafiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_notavendaconsumidor ON notavendaconsumidor;
DROP TRIGGER IF EXISTS del_pafecf_notavendaconsumidor ON notavendaconsumidor;
DROP TRIGGER IF EXISTS ins_upd_pafecf_itemnotafiscal ON itemnotafiscal;
DROP TRIGGER IF EXISTS del_pafecf_itemnotafiscal ON itemnotafiscal;
DROP TRIGGER IF EXISTS ins_upd_pafecf_caixa ON caixa;
DROP TRIGGER IF EXISTS del_pafecf_caixa ON caixa;
DROP TRIGGER IF EXISTS ins_upd_pafecf_estoquepafecf ON estoquepafecf;
DROP TRIGGER IF EXISTS del_pafecf_estoquepafecf ON estoquepafecf;
DROP TRIGGER IF EXISTS ins_envio_fisco_estoque_mensal_pafecf ON caixa;
DROP TRIGGER IF EXISTS ins_envio_fisco_reducaoz_pafecf ON reducaoz;

DROP PROCEDURE IF EXISTS DROP_FUNCTION;
CREATE PROCEDURE DROP_FUNCTION(_SCHEMA VARCHAR(255), FUNC_NAME VARCHAR(255))
AS $$
DECLARE COMMAND TEXT;
BEGIN
	IF (FUNC_NAME IS NULL) THEN
	  RETURN;
	END IF;
	
	IF(FUNC_NAME ILIKE '') THEN
	  RETURN;
	END IF;

	IF(_SCHEMA IS NULL OR _SCHEMA ILIKE '') THEN
	  _SCHEMA = 'public';
	END IF;
	   
	FOR COMMAND IN
	  SELECT 'DROP FUNCTION IF EXISTS ' || _SCHEMA || '.' || oid::regprocedure AS command 
	    FROM pg_proc WHERE proname ILIKE FUNC_NAME 
		 AND pg_function_is_visible(oid) 
	LOOP
	  EXECUTE COMMAND;
	  RAISE NOTICE 'FUNÇÃO %.% REMOVIDA COM SUCESSO!', _SCHEMA, FUNC_NAME;
	END LOOP;
END;
$$  LANGUAGE plpgsql;

CALL DROP_FUNCTION('public', 'atualizar_estoquepafecf');
CALL DROP_FUNCTION('public', 'is_pafecf');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_empresa');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_item');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_formapagamentoefetuada');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_ecf');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_reducaoz');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_totalizadorparcialreducaoz');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_cupomfiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_itemcupomfiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_suprimento');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_sangriaefetuada');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_comprovantenaofiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_documentonaofiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_notafiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_notavendaconsumidor');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_itemnotafiscal');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_caixa');
CALL DROP_FUNCTION('public', 'autenticar_pafecf_estoquepafecf');
CALL DROP_FUNCTION('public', 'atualizar_envio_fisco_estoque_mensal_pafecf');
CALL DROP_FUNCTION('public', 'atualizar_envio_fisco_reducaoz_pafecf');
CALL DROP_FUNCTION('public', 'gerar_xml_envio_fisco_reducaoz');
CALL DROP_FUNCTION('public', 'gerar_xml_envio_fisco_estoque');
CALL DROP_FUNCTION('public', 'exportar_carga_automatica_configuracao_paf_ecf');
CALL DROP_FUNCTION('public', 'busca_totalizador_parcial_reducao_z');
CALL DROP_FUNCTION('public', 'persiste_totalizador_parcial_reducao_z');
CALL DROP_FUNCTION('public', 'persiste_dados_cliente');
CALL DROP_FUNCTION('public', 'persiste_entrega');
CALL DROP_FUNCTION('public', 'persiste_devolucao');
CALL DROP_FUNCTION('public', 'persiste_item_cupom_fiscal');
CALL DROP_FUNCTION('public', 'persiste_item_devolucao');
CALL DROP_FUNCTION('public', 'persiste_relatorio_desconto');
CALL DROP_FUNCTION('public', 'busca_reducao_z');
CALL DROP_FUNCTION('public', 'persiste_bloqueio_sessao');
CALL DROP_FUNCTION('public', 'persiste_cupom_fiscal');
CALL DROP_FUNCTION('public', 'persiste_cupom_fiscal_eletronico');
CALL DROP_FUNCTION('public', 'persiste_suprimento');
CALL DROP_FUNCTION('public', 'persiste_entrega');
CALL DROP_FUNCTION('public', 'busca_cesta_basica_cupom');
CALL DROP_FUNCTION('public', 'busca_cupom_fiscal');
CALL DROP_FUNCTION('public', 'busca_item_cupom_fiscal');
CALL DROP_FUNCTION('public', 'busca_sangria_efetuada');
CALL DROP_FUNCTION('public', 'busca_suprimento');
CALL DROP_FUNCTION('public', 'persiste_item_cesta_basica_cupom');
CALL DROP_FUNCTION('public', 'persiste_pagamento_tef');	
CALL DROP_FUNCTION('public', 'persiste_cesta_basica_cupom');
CALL DROP_FUNCTION('public', 'persiste_forma_pagamento_efetuada');