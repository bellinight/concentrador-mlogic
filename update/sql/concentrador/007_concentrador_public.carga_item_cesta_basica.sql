/*
 * Esta função realiza a gravação dos Itens da Cesta básica no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_item_cesta_basica(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbItensCestaBasicaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbItensCestaBasicaTemp (
	 iditem 			 INTEGER NOT NULL, 
	 iditemcesta 	     INTEGER NOT NULL,
	 preco  			 NUMERIC(18,4) NOT NULL,
	 quantidade 		 NUMERIC(18,4) NOT NULL);
	 /*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbItensCestaBasicaTemp
		SELECT * FROM json_populate_recordset(NULL::tbItensCestaBasicaTemp, p_dados);
	 /* TRATAMENTO PARA VALORES NEGATIVOS OU ZERADOS */
	 DELETE FROM tbItensCestaBasicaTemp WHERE preco <= 0;
	/*QUANDO ALGUM ITEM DA CESTA FOR INSERIDO*/
	INSERT INTO itenscestabasica
	 SELECT ((SELECT COALESCE(MAX(id), 0) FROM itenscestabasica) + (ROW_NUMBER() OVER (ORDER BY itenscestabasica.id))) AS id,
		 tb1.iditem, tb1.iditemcesta, tb1.preco, tb1.quantidade, null AS desativado, true AS modificado
		 FROM tbItensCestaBasicaTemp AS tb1
		 LEFT JOIN itenscestabasica AS itenscestabasica ON itenscestabasica.iditem = tb1.iditem AND itenscestabasica.iditemcesta = tb1.iditemcesta
		 WHERE (itenscestabasica.iditem IS NULL) OR (itenscestabasica.iditem = tb1.iditem AND itenscestabasica.iditemcesta IS NULL);
	/*QUANDO ALGUM ITEM DA CESTA FOR ALTERADO*/
	UPDATE itenscestabasica SET iditem = tb1.iditem, iditemcesta = tb1.iditemcesta,
		 preco = tb1.preco, quantidade = tb1.quantidade, desativado = null, modificado = true
		 FROM tbItensCestaBasicaTemp AS tb1
		 WHERE itenscestabasica.iditem = tb1.iditem AND itenscestabasica.iditemcesta = tb1.iditemcesta;
	 /*QUANDO ALGUM ITEM DA CESTA FOR EXCLUÍDO*/
	UPDATE itenscestabasica SET desativado = CURRENT_DATE
	 FROM (SELECT itenscestabasica.iditem, itenscestabasica.iditemcesta FROM itenscestabasica
			LEFT JOIN tbItensCestaBasicaTemp AS tb1 
		    ON tb1.iditem = itenscestabasica.iditem AND itenscestabasica.iditemcesta = tb1.iditemcesta
			WHERE tb1.iditem IS NULL AND tb1.iditemcesta IS NULL AND itenscestabasica.desativado IS NULL) AS tb1
	 WHERE itenscestabasica.iditem = tb1.iditem AND itenscestabasica.iditemcesta = tb1.iditemcesta;	
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbItensCestaBasicaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;