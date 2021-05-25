/*
 * Esta função realiza a gravação dos Itens Promoção A Partir de no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_item_promocao_a_partir_de(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbItemPromocaoAPartirDeTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbItemPromocaoAPartirDeTemp (
			id_empresa INTEGER NOT NULL,
            id_item_principal INTEGER NOT NULL,
            id_item_secundario INTEGER NOT NULL);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbItemPromocaoAPartirDeTemp
		SELECT * FROM json_populate_recordset(NULL::tbItemPromocaoAPartirDeTemp, p_dados);
	/*QUANDO ALGUM ITEM DA PROMOÇÃO A PARTIR DE FOR INSERIDO*/
	INSERT INTO itempromocaolevepague
	SELECT tb1.id_empresa, tb1.id_item_principal, tb1.id_item_secundario,
	null AS desativado, true AS modificado
		 FROM tbItemPromocaoAPartirDeTemp AS tb1
		 LEFT JOIN itempromocaolevepague AS itempromocaolevepague
		 ON itempromocaolevepague.id_empresa = tb1.id_empresa
		 AND itempromocaolevepague.id_item_principal = tb1.id_item_principal
		 AND itempromocaolevepague.id_item_secundario = tb1.id_item_secundario
	WHERE itempromocaolevepague.id_empresa IS NULL
	AND itempromocaolevepague.id_item_principal IS NULL
	AND itempromocaolevepague.id_item_secundario IS NULL;
	/*QUANDO ALGUM ITEM DA PROMOÇÃO A PARTIR DE FOR ATIVADO*/
	UPDATE itempromocaolevepague
		 SET desativado = null, modificado = true
		 FROM tbItemPromocaoAPartirDeTemp tb1
		 WHERE itempromocaolevepague.id_empresa = tb1.id_empresa
		 AND itempromocaolevepague.id_item_principal = tb1.id_item_principal
		 AND itempromocaolevepague.id_item_secundario = tb1.id_item_secundario
		 AND itempromocaolevepague.desativado IS NOT NULL;
	 /*QUANDO ALGUM ITEM DA PROMOÇÃO A PARTIR DE FOR EXCLUÍDO*/
	UPDATE itempromocaolevepague
	SET desativado = CURRENT_DATE
	 FROM (SELECT itempromocaolevepague.id_empresa, itempromocaolevepague.id_item_principal,
			itempromocaolevepague.id_item_secundario FROM itempromocaolevepague
			LEFT JOIN tbItemPromocaoAPartirDeTemp AS tb1
		    ON tb1.id_empresa = itempromocaolevepague.id_empresa
			AND tb1.id_item_principal = itempromocaolevepague.id_item_principal
			AND tb1.id_item_secundario = itempromocaolevepague.id_item_secundario
			WHERE tb1.id_empresa IS NULL AND tb1.id_item_principal IS NULL
			AND tb1.id_item_secundario IS NULL AND itempromocaolevepague.desativado IS NULL) AS tb1
			WHERE tb1.id_empresa = itempromocaolevepague.id_empresa
			AND tb1.id_item_principal = itempromocaolevepague.id_item_principal
			AND tb1.id_item_secundario = itempromocaolevepague.id_item_secundario;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbItemPromocaoAPartirDeTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;