/*
 * Esta função realiza a gravação da Promoção Campanha Grupo De Venda no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_campanha_grupo_venda(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromoCampGrupoDeVendaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromoCampGrupoDeVendaTemp (
			id INTEGER NOT NULL,
            descricao VARCHAR (50) NOT NULL);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromoCampGrupoDeVendaTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromoCampGrupoDeVendaTemp, p_dados);
	/*QUANDO ALGUM GRUPO DE VENDA DA PROMOÇÃO CAMPANHA FOR INSERIDA*/
	INSERT INTO promo_camp_grupo_de_venda
	SELECT t_temp.id, t_temp.descricao,
	null as desativado, true AS modificado
	FROM tbPromoCampGrupoDeVendaTemp AS t_temp
	LEFT JOIN promo_camp_grupo_de_venda AS pcgv ON pcgv.id = t_temp.id
	WHERE pcgv.id IS NULL;
	/*QUANDO ALGUM GRUPO DE VENDA DA PROMOÇÃO CAMPANHA FOR ALTERADA*/
	UPDATE promo_camp_grupo_de_venda
		 SET descricao = t_temp.descricao,
		 desativado = null, modificado = true
		 FROM tbPromoCampGrupoDeVendaTemp AS t_temp
		 JOIN promo_camp_grupo_de_venda pcgv ON pcgv.id = t_temp.id
		 WHERE promo_camp_grupo_de_venda.id = t_temp.id;
	/*QUANDO ALGUM GRUPO DE VENDA DA PROMOÇÃO CAMPANHA FOR EXCLUÍDA*/	 
	UPDATE promo_camp_grupo_de_venda
	SET desativado = CURRENT_DATE
	FROM
		(SELECT pcgv.id 
		FROM promo_camp_grupo_de_venda pcgv
		LEFT JOIN tbPromoCampGrupoDeVendaTemp AS t_temp
		ON t_temp.id = pcgv.id
		WHERE t_temp.id IS NULL AND pcgv.desativado IS NULL
		) AS desativar
		WHERE desativar.id = promo_camp_grupo_de_venda.id;
	/*Excluir tabela temporária*/
	DROP TABLE tbPromoCampGrupoDeVendaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;