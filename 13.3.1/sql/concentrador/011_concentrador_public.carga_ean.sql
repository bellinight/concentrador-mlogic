/*
 * Esta função realiza a gravação dos EANs no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_ean(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbEanTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbEanTemp ( 
        iditem INTEGER,
        ean VARCHAR );
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbEanTemp
		SELECT * FROM json_populate_recordset(NULL::tbEanTemp, p_dados);
	/*QUANDO ALGUM EAN FOR INSERIDO*/
	INSERT INTO ean 
		SELECT ((SELECT COALESCE(MAX(id), 0) FROM ean) + (ROW_NUMBER() OVER (ORDER BY ean.id))) AS id, 
		tb1.iditem, SUBSTRING(tb1.ean, 1, 20), null AS desativado, false AS modificado 
		FROM tbEanTemp AS tb1 
		LEFT JOIN ean AS ean ON ean.iditem = tb1.iditem AND ean.ean = SUBSTRING(tb1.ean, 1, 20) 
		WHERE (ean.iditem IS NULL) OR (ean.iditem = tb1.iditem AND ean.ean IS NULL); 
	/*QUANDO ALGUM EAN JÁ EXISTENTE FOR ATIVADO*/
	UPDATE ean SET iditem = tb1.iditem, ean = SUBSTRING(tb1.ean, 1, 20), 
		desativado = null, modificado = true 
		FROM tbEanTemp AS tb1 
		WHERE ean.iditem = tb1.iditem AND ean.ean = SUBSTRING(tb1.ean, 1, 20) AND ean.desativado IS NOT NULL; 
	/*QUANDO ALGUM EAN FOR EXCLUÍDO*/
	UPDATE ean SET desativado = CURRENT_DATE 
		FROM (SELECT ean.iditem, ean.ean FROM ean 
		LEFT JOIN tbEanTemp AS tb1 ON tb1.iditem = ean.iditem AND ean.ean = SUBSTRING(tb1.ean, 1, 20) 
		WHERE tb1.iditem IS NULL AND SUBSTRING(tb1.ean, 1, 20) IS NULL AND ean.desativado IS NULL ) AS tb1 
		WHERE ean.iditem = tb1.iditem AND ean.ean = SUBSTRING(tb1.ean, 1, 20); 
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbEanTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;