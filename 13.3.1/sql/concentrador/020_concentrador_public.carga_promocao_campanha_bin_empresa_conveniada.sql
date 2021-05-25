/*
 * Esta função realiza a gravação da Promoção Campanha Bins Empresa Conveniada no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_campanha_bin_empresa_conveniada(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromoCampBinsEmpConveniadaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromoCampBinsEmpConveniadaTemp (
			id_empresa_conveniada INTEGER NOT NULL,
            bin INTEGER NOT NULL);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromoCampBinsEmpConveniadaTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromoCampBinsEmpConveniadaTemp, p_dados);
	/*ANTES DE IMPORTAR ALGUM BIN APAGAR A TABELA, POIS NÃO IMPORTA AS INFORMAÇÕES HISTÓRICAS.*/
    DELETE FROM promo_camp_bins_emp_conveniada;
	 /*Condicionais irão dizer se a operação é de inserção/atualização/desativação */
	 /*QUANDO ALGUMA EMPRESA CONVENIADA DA PROMOÇÃO CAMPANHA FOR INSERIDA*/
	INSERT INTO promo_camp_bins_emp_conveniada (id_empresa_conveniada, bin)
	(SELECT temp.id_empresa_conveniada, temp.bin
	 FROM tbPromoCampBinsEmpConveniadaTemp AS temp
	  JOIN promo_camp_empresa_conveniada emp
	   ON emp.id = temp.id_empresa_conveniada
	 WHERE emp.desativado IS NULL);
	/*EXCLUI A TABELA TEMPORÁRIA*/	 	 
	DROP TABLE tbPromoCampBinsEmpConveniadaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;