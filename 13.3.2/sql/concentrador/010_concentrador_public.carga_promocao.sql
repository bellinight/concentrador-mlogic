/*
 * Esta função realiza a gravação das Promoções no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromocaoTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromocaoTemp (
	 id INTEGER NOT NULL,
	 nome VARCHAR NOT NULL,
	 datainicio TIMESTAMP NOT NULL,
	 datafim TIMESTAMP NOT NULL);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON		
   * 
   *Exemplo do JSON recebido: 
   *[{"id":10373,"nome":"PROMOCAO PADRAO ( 30/07/2019 a 30/08/2019 )","datainicio":"2019-07-30T00:00:00","datafim":"2019-08-30T23:59:00"},{"id":10374,"nome":"PROMO MAC ( 30/07/2019 a 30/08/2019 )","datainicio":"2019-07-30T00:00:00","datafim":"2019-08-30T23:59:00"}]
   */
	INSERT INTO tbPromocaoTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromocaoTemp, p_dados);	
	/*QUANDO ALGUMA PROMOÇÂO FOR INSERIDA*/
	INSERT INTO promocao
	 SELECT tb1.id, SUBSTRING(tb1.nome, 1, 50), tb1.datainicio, tb1.datafim, null AS desativado, true AS modificado
		 FROM tbPromocaoTemp AS tb1
		 LEFT JOIN promocao AS promocao ON promocao.id = tb1.id
		 WHERE promocao.id IS NULL;
	/*QUANDO ALGUMA PROMOÇÃO FOR ALTERADA*/
	UPDATE promocao SET nome = SUBSTRING(tb1.nome, 1, 50), datainicio = tb1.datainicio,
		 datafim = tb1.datafim, desativado = null, modificado = true
		 FROM tbPromocaoTemp tb1
		 WHERE promocao.id = tb1.id;
	 /*QUANDO ALGUMA PROMOÇÃO FOR EXCLUÍDA*/
	UPDATE promocao SET desativado = CURRENT_DATE
	 FROM (SELECT promocao.id FROM promocao
			LEFT JOIN tbPromocaoTemp AS tb1 ON tb1.id = promocao.id
		    WHERE tb1.id IS NULL AND promocao.desativado IS NULL ) AS tb1
	 WHERE tb1.id = promocao.id;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbPromocaoTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;