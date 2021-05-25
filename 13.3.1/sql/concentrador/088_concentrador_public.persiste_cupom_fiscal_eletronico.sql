--------------------------------------------------------------------------
-- Esta função realiza a gravação dos dados do Cupom Fiscal Eletrônico. --
--------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_cupom_fiscal_eletronico;
DROP FUNCTION IF EXISTS public.persiste_cupom_fiscal_eletronico (
p_ccf integer,
	p_serie_ecf character varying,
	p_serie character varying,
	p_numero character varying,
	p_cd_tipo_emissao character varying,
	p_tipo_impressao character varying,
	p_ambiente character varying,
	p_consumidor_final character varying,
	p_presencial character varying,
	p_versao_aplicativo character varying,
	p_cgc_autorizados character varying,
	p_tipo_finalidade character varying,
	p_observacao character varying,
	p_situacao character varying,
	p_dh_autorizacao timestamp without time zone,
	p_msg_retornada character varying,
	p_dh_contingencia timestamp without time zone,
	p_justificativa character varying,
	p_chave_eletronica character varying,
	p_xml_gerado text,
	p_versao_xml character varying,
	p_total_tributos numeric,
	p_protocolo_autorizacao character varying,
	p_total_icms numeric,
	p_digest_value character varying,
	p_danfe_emitido boolean,
	p_dh_emissao timestamp without time zone,
	p_url_qrcode text,
	p_coo integer,
	p_tributo_federal numeric,
	p_tributo_estadual numeric,
	p_tributo_municial numeric);
	
CREATE OR REPLACE FUNCTION persiste_cupom_fiscal_eletronico
	(p_ccf 			integer
	,p_serie_ecf		character varying(50)
	,p_serie		integer
	,p_numero 		integer
	,p_cd_tipo_emissao	character varying(1)
	,p_tipo_impressao	character varying(1)
	,p_ambiente		character varying(1) 
	,p_consumidor_final	character varying(1)
	,p_presencial		character varying(1)
	,p_versao_aplicativo	character varying(50)
	,p_cgc_autorizados	character varying(150)
	,p_tipo_finalidade	character varying(1)
	,p_observacao		character varying(5000)
	,p_situacao		character varying(1)
	,p_dh_autorizacao	timestamp
	,p_msg_retornada	character varying(5000)
	,p_dh_contingencia	timestamp
	,p_justificativa	character varying(256)
	,p_chave_eletronica	Character varying(44)
	,p_xml_gerado  		text
	,p_versao_xml   	character varying(5)
	,p_total_tributos  	numeric(15,2)
	,p_protocolo_autorizacao character varying(50)
	,p_total_icms		numeric(15,2)
	,p_digest_value 	character varying(50)
	,p_danfe_emitido 	boolean
	,p_dh_emissao		timestamp
	,p_url_qrcode		text
	,p_coo INTEGER
	,p_tributo_federal numeric
	,p_tributo_estadual numeric
	,p_tributo_municipal numeric) RETURNS void AS $$

DECLARE 
	id_cupom_fiscal INTEGER;
	
BEGIN
	id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);  		

	if (p_situacao != 'E')
	THEN
		IF (busca_cupom_fiscal_eletronico(id_cupom_fiscal) = FALSE) 
		THEN
			INSERT INTO cupom_fiscal_eletronico 
				(cupom_fiscal
				,serie
				,numero
				,cd_tipo_emissao
				,tipo_impressao
				,ambiente
				,consumidor_final
				,presencial
				,versao_aplicativo
				,cgc_autorizados
				,tipo_finalidade
				,observacao
				,situacao
				,dh_autorizacao
				,msg_retornada
				,dh_contingencia
				,justificativa
				,chave_eletronica
				,xml_gerado 
				,versao_xml 
				,total_tributos 
				,protocolo_autorizacao 
				,total_icms 
				,digest_value 
				,danfe_emitido
				,dh_emissao
				,url_qrcode
				,tributo_federal
				,tributo_estadual
				,tributo_municipal) 
				
			VALUES	(id_cupom_fiscal
				,p_serie
				,p_numero
				,p_cd_tipo_emissao
				,p_tipo_impressao
				,p_ambiente
				,p_consumidor_final
				,p_presencial
				,p_versao_aplicativo
				,p_cgc_autorizados
				,p_tipo_finalidade
				,p_observacao
				,p_situacao
				,p_dh_autorizacao
				,p_msg_retornada
				,p_dh_contingencia
				,p_justificativa
				,p_chave_eletronica
				,p_xml_gerado 
				,p_versao_xml 
				,p_total_tributos 
				,p_protocolo_autorizacao 
				,p_total_icms 
				,p_digest_value 
				,p_danfe_emitido
				,p_dh_emissao
				,p_url_qrcode
				,p_tributo_federal
				,p_tributo_estadual
				,p_tributo_municipal);
		ELSE
			UPDATE cupom_fiscal_eletronico
			   SET 	serie = p_serie
				,numero = p_numero
				,cd_tipo_emissao = p_cd_tipo_emissao
				,tipo_impressao = p_tipo_impressao
				,ambiente = p_ambiente
				,consumidor_final = p_consumidor_final 
				,presencial = p_presencial 
				,versao_aplicativo = p_versao_aplicativo 
				,cgc_autorizados = p_cgc_autorizados 
				,tipo_finalidade = p_tipo_finalidade 
				,observacao = p_observacao 
				,situacao = p_situacao 
				,dh_autorizacao = p_dh_autorizacao 
				,msg_retornada = p_msg_retornada 
				,dh_contingencia = p_dh_contingencia 
				,justificativa = p_justificativa 
				,chave_eletronica = p_chave_eletronica 
				,xml_gerado = p_xml_gerado 
				,versao_xml = p_versao_xml 
				,total_tributos = p_total_tributos 
				,protocolo_autorizacao = p_protocolo_autorizacao 
				,total_icms = p_total_icms 
				,digest_value = p_digest_value 
				,danfe_emitido = p_danfe_emitido
				,dh_emissao = p_dh_emissao
				,url_qrcode = p_url_qrcode
				,tributo_federal = p_tributo_federal
				,tributo_estadual = p_tributo_estadual
				,tributo_municipal = p_tributo_municipal
			 WHERE	cupom_fiscal = id_cupom_fiscal; 
		END IF;
	END IF;
END;
$$  LANGUAGE plpgsql;

