/*
 * Esta função realiza a gravação da Promoção Campanha no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_campanha(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromocaoCampanhaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromocaoCampanhaTemp (
			id_campanha INTEGER NOT NULL,
            descricao VARCHAR (50) NOT NULL,
			data_inicial TIMESTAMP NOT NULL,
			data_final TIMESTAMP NOT NULL,
			data_criacao TIMESTAMP NOT NULL,
			tipo_valor_percentual BOOLEAN NOT NULL,
			tipo_campanha BOOLEAN NOT NULL,
			id_item INTEGER NOT NULL,
			valor NUMERIC(18,4) NOT NULL,
			id_empresa_conveniada INTEGER,
			id_grupo_de_venda INTEGER);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromocaoCampanhaTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromocaoCampanhaTemp, p_dados);
	/* DELETE para tratar registros com valor menor que zero*/
	DELETE FROM tbPromocaoCampanhaTemp WHERE valor <= 0;
	/*ANTES DE IMPORTAR ALGUMA PROMOÇÃO CAMPANHA APAGAR A TABELA, POIS NÃO IMPORTA
    AS INFORMAÇÕES HISTÓRICAS (CONVERSADO COM GERENTE 03/08/2018) */
    DELETE FROM promocao_campanha;
	/*QUANDO ALGUMA PROMOÇÃO CAMPANHA FOR INSERIDA*/
	INSERT INTO promocao_campanha
	(id_campanha, descricao, data_inicial, data_final, data_criacao,
	tipo_valor_percentual, tipo_campanha, id_item, valor,
	id_empresa_conveniada, id_grupo_de_venda, desativado, modificado)
	(SELECT tbpc.id_campanha, tbpc.descricao,
	tbpc.data_inicial, tbpc.data_final, tbpc.data_criacao,
	tbpc.tipo_valor_percentual, tbpc.tipo_campanha,
	tbpc.id_item, tbpc.valor,
	NULLIF(tbpc.id_empresa_conveniada, 0) AS id_empresa_conveniada,
	NULLIF(tbpc.id_grupo_de_venda, 0) AS id_grupo_de_venda,
	null as desativado, true AS modificado
	FROM tbPromocaoCampanhaTemp AS tbpc);
	/*Excluir tabela temporária*/
	DROP TABLE tbPromocaoCampanhaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;