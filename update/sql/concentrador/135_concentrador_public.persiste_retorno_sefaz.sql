-------------------------------------------------------------------
-- Esta função realiza a gravação dos dados do Retorno da Sefaz. --
-------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_retorno_sefaz;
CREATE OR REPLACE FUNCTION public.persiste_retorno_sefaz(
	p_chave_eletronica	CHARACTER VARYING(44),
	p_tipo_retorno		CHARACTER VARYING(1),
	p_codigo_status		INTEGER,
	p_descricao_status	TEXT,
	p_xml_retornado		TEXT) RETURNS void AS $$
	
DECLARE 
	v_id_cupom_fiscal_eletronico	INTEGER;
	v_ja_existe 			BOOLEAN;
	
BEGIN
	---------------------------------------------------------
	-- Buscando o Cupom Fiscal Eletrônico através da Chave --
	---------------------------------------------------------
	SELECT id
	  INTO v_id_cupom_fiscal_eletronico 
	  FROM cupom_fiscal_eletronico 
	 WHERE chave_eletronica =  p_chave_eletronica;

	IF (v_id_cupom_fiscal_eletronico IS NULL)
	THEN
		RAISE EXCEPTION 'Erro ao inserir o Retorno da Sefaz de código do status % para a NFC-e de chave eletrônica %.', p_codigo_status, p_chave_eletronica
		      USING DETAIL = 'Não foi encontrado um registro na tabela cupom_fiscal_eletronico com essa chave.';
	END IF;
	
	RAISE NOTICE 'Id da tabela cupom_fiscal_eletronico para a chave %: %', p_chave_eletronica, v_id_cupom_fiscal_eletronico;

	--------------------------------------------------
	 -- Verificando se já existe o Retorno da Sefaz --
	 -------------------------------------------------
	 SELECT EXISTS (SELECT id 
			  FROM retorno_sefaz 
			 WHERE cupom_fiscal_eletronico = v_id_cupom_fiscal_eletronico
			   AND codigo_status = p_codigo_status)
	   INTO v_ja_existe;

	RAISE NOTICE 'Já existe o Retorno da Sefaz de Código do Status % para a NFC-e de chave %? %', p_codigo_status, p_chave_eletronica, v_ja_existe;	

	----------------------------------
	 -- Executando a respectiva DML --
	 ---------------------------------
	 IF (v_ja_existe)
	 THEN		
		UPDATE retorno_sefaz
		   SET tipo_retorno = p_tipo_retorno,
			   codigo_status = p_codigo_status,
			   descricao_status = p_descricao_status,
			   xml_retornado = p_xml_retornado
		 WHERE cupom_fiscal_eletronico = v_id_cupom_fiscal_eletronico;
	 ELSE
		INSERT INTO retorno_sefaz 
			(cupom_fiscal_eletronico
			,tipo_retorno
			,codigo_status
			,descricao_status
			,xml_retornado) 
		VALUES 
			(v_id_cupom_fiscal_eletronico
			,p_tipo_retorno
			,p_codigo_status
			,p_descricao_status
			,p_xml_retornado);	
	 END IF;
 END;
$$  LANGUAGE plpgsql;
	 
	 
	 
	
