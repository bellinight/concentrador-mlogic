/*
 * Esta função realiza a gravação da Promoção Campanha Empresa Conveniada no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_campanha_empresa_conveniada(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromoCampEmpresaConveniadaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromoCampEmpresaConveniadaTemp (
			id INTEGER NOT NULL,
            descricao VARCHAR (50) NOT NULL,
            rede VARCHAR (10),
			bandeira VARCHAR (5));
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromoCampEmpresaConveniadaTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromoCampEmpresaConveniadaTemp, p_dados);
	 /*QUANDO ALGUMA EMPRESA CONVENIADA DA PROMOÇÃO CAMPANHA FOR INSERIDA*/
	INSERT INTO promo_camp_empresa_conveniada
	SELECT tbpcec.id, tbpcec.descricao, lpad(tbpcec.rede,5,'0') as rede,
	lpad(tbpcec.bandeira,5,'0') as bandeira,
	null as desativado, true AS modificado
		 FROM tbPromoCampEmpresaConveniadaTemp AS tbpcec
		 LEFT JOIN promo_camp_empresa_conveniada AS pcec ON pcec.id = tbpcec.id
		 WHERE pcec.id IS NULL;
	/*QUANDO ALGUMA EMPRESA CONVENIADA DA PROMOÇÃO CAMPANHA FOR ALTERADA*/
	UPDATE promo_camp_empresa_conveniada
		 SET descricao = tbpcec.descricao, 
		 rede = lpad(tbpcec.rede,5,'0'), bandeira = lpad(tbpcec.bandeira,5,'0'),
		 desativado = null, modificado = true
		 FROM tbPromoCampEmpresaConveniadaTemp AS tbpcec
		 INNER JOIN promo_camp_empresa_conveniada AS pcec
		 ON pcec.id = tbpcec.id
		 WHERE promo_camp_empresa_conveniada.id = tbpcec.id;
	 /*QUANDO ALGUMA EMPRESA CONVENIADA DA PROMOÇÃO CAMPANHA FOR EXCLUÍDA*/
	UPDATE promo_camp_empresa_conveniada
	SET desativado = CURRENT_DATE
	 FROM (SELECT pcec.id
			FROM promo_camp_empresa_conveniada AS pcec
			LEFT JOIN tbPromoCampEmpresaConveniadaTemp AS tbpcec
			ON tbpcec.id = pcec.id
			WHERE tbpcec.id IS NULL AND pcec.desativado IS NULL
			) AS desativar
			WHERE desativar.id = promo_camp_empresa_conveniada.id;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbPromoCampEmpresaConveniadaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;