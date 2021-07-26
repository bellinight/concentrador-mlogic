/*
 * Esta função realiza a gravação das Unidades no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_unidade(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
    /*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbUnidadeTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbUnidadeTemp ( 
        id INTEGER NOT NULL, 
        sigla VARCHAR);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON 
   *
   *Exemplo do JSON recebido: 
   *[{"id":1,"sigla":"UN"},{"id":2,"sigla":"KG"},{"id":3,"sigla":"PCT"}]
   */  
	INSERT INTO tbUnidadeTemp
		SELECT * FROM json_populate_recordset(NULL::tbUnidadeTemp, p_dados);
	/*QUANDO ALGUMA UNIDADE FOR INSERIDA*/
	INSERT INTO unidade 
		SELECT tb1.id, null AS nome, SUBSTRING(tb1.sigla, 1, 5), false AS modificado, null AS desativado 
		FROM tbUnidadeTemp AS tb1 
		LEFT JOIN unidade AS unidade ON unidade.id = tb1.id 
		WHERE unidade.id IS NULL; 
	/*QUANDO ALGUMA UNIDADE FOR ALTERADA*/	
	UPDATE unidade SET sigla = SUBSTRING(tb1.sigla, 1, 5), 
		modificado = true, desativado = null 
		FROM tbUnidadeTemp tb1 
		WHERE unidade.id = tb1.id;
	/*QUANDO ALGUMA UNIDADE FOR EXCLUÍDA*/	 
	UPDATE unidade SET desativado = CURRENT_DATE 
		FROM (SELECT unidade.id FROM unidade 
		 LEFT JOIN tbUnidadeTemp AS tb1 ON tb1.id = unidade.id 
		 WHERE tb1.id IS NULL AND unidade.desativado IS NULL 
		 ) AS tb1 
		 WHERE tb1.id = unidade.id;
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbUnidadeTemp;

	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;