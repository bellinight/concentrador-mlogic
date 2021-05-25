/*
 * Esta função realiza a gravação das Promoções A partir de no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_a_partir_de(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromocaoAPartirDeTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromocaoAPartirDeTemp (
			id_empresa INTEGER NOT NULL,
            id_item_principal INTEGER NOT NULL,
            datainicio TIMESTAMP,
            datafim TIMESTAMP,
            descricao VARCHAR); 
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromocaoAPartirDeTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromocaoAPartirDeTemp, p_dados);		
	/*QUANDO ALGUMA PROMOÇÃO A PARTIR DE FOR INSERIDA*/
	INSERT INTO promocaolevepague
	SELECT tb1.id_empresa, tb1.id_item_principal, tb1.datainicio, tb1.datafim,
	 SUBSTRING(tb1.descricao, 1, 50), null AS desativado, true AS modificado
		 FROM tbPromocaoAPartirDeTemp AS tb1
		 LEFT JOIN promocaolevepague AS promocaolevepague
		 ON promocaolevepague.id_empresa = tb1.id_empresa
		 AND promocaolevepague.id_item_principal = tb1.id_item_principal
	WHERE promocaolevepague.id_empresa IS NULL AND promocaolevepague.id_item_principal IS NULL;
	/*QUANDO ALGUMA PROMOÇÃO A PARTIR DE FOR ALTERADA*/
	UPDATE promocaolevepague
		 SET datainicio = tb1.datainicio, datafim = tb1.datafim,
		 descricao = SUBSTRING(tb1.descricao, 1, 50), desativado = null, modificado = true
		 FROM tbPromocaoAPartirDeTemp AS tb1
		 WHERE promocaolevepague.id_empresa = tb1.id_empresa
		 AND promocaolevepague.id_item_principal = tb1.id_item_principal;
	 /*QUANDO ALGUMA PROMOÇÃO A PARTIR DE FOR EXCLUÍDA*/
	UPDATE promocaolevepague
	SET desativado = CURRENT_DATE
	 FROM (SELECT promocaolevepague.id_empresa, promocaolevepague.id_item_principal FROM promocaolevepague
			LEFT JOIN tbPromocaoAPartirDeTemp AS tb1
			ON tb1.id_empresa = promocaolevepague.id_empresa
		    AND tb1.id_item_principal = promocaolevepague.id_item_principal
	 WHERE tb1.id_empresa IS NULL AND tb1.id_item_principal IS NULL AND promocaolevepague.desativado IS NULL
	 ) AS tb1
	 WHERE tb1.id_empresa = promocaolevepague.id_empresa
	 AND tb1.id_item_principal = promocaolevepague.id_item_principal;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbPromocaoAPartirDeTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;