/*
 * Esta função realiza a gravação dos Itens da Promoção no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_item_promocao(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbItemPromocaoTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbItemPromocaoTemp (
	 idpromocao INTEGER,
	 iditem INTEGER NOT NULL,
	 precopromocao NUMERIC(18,4) NOT NULL);
	 /*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbItemPromocaoTemp
		SELECT * FROM json_populate_recordset(NULL::tbItemPromocaoTemp, p_dados);
	/* TRATAMENTO PARA VALORES NEGATIVOS OU ZERADOS */
	DELETE FROM tbItemPromocaoTemp WHERE precopromocao <= 0;
	/*QUANDO ALGUM ITEM DE PROMOÇÃO FOR INSERIDO*/
	INSERT INTO itempromocao
	(idpromocao, iditem, precopromocao, desativado, modificado)
	 SELECT tb1.idpromocao, tb1.iditem, tb1.precopromocao, null AS desativado, true AS modificado
		 FROM tbItemPromocaoTemp AS tb1
		 LEFT JOIN itempromocao AS itempromocao ON itempromocao.idpromocao = tb1.idpromocao
		 AND itempromocao.iditem = tb1.iditem
		 WHERE (itempromocao.idpromocao IS NULL) OR (itempromocao.idpromocao = tb1.idpromocao AND itempromocao.iditem IS NULL);
	/*QUANDO ALGUM ITEM DE PROMOÇÃO FOR ALTERADO*/
	UPDATE itempromocao SET idpromocao = tb1.idpromocao, iditem = tb1.iditem,
		 precopromocao = tb1.precopromocao, desativado = null, modificado = true
		 FROM tbItemPromocaoTemp AS tb1
		 WHERE itempromocao.idpromocao = tb1.idpromocao AND itempromocao.iditem = tb1.iditem;
	 /*QUANDO ALGUM ITEM DE PROMOÇÃO FOR EXCLUÍDO*/
	UPDATE itempromocao SET desativado = CURRENT_DATE
	 FROM (SELECT itempromocao.idpromocao, itempromocao.iditem FROM itempromocao
			LEFT JOIN tbItemPromocaoTemp AS tb1
			ON tb1.idpromocao = itempromocao.idpromocao AND itempromocao.iditem = tb1.iditem
		    WHERE tb1.idpromocao IS NULL AND tb1.iditem IS NULL AND itempromocao.desativado IS NULL) AS tb1
	 WHERE itempromocao.idpromocao = tb1.idpromocao AND itempromocao.iditem = tb1.iditem;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbItemPromocaoTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;