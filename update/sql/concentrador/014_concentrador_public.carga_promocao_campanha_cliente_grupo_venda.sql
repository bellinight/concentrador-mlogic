/*
 * Esta função realiza a gravação da Promoção Campanha Grupo De Venda no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_campanha_cliente_grupo_venda(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbPromoCampGrupoDeVendaTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbPromoCampClientesGrupoDeVendaTemp (
			id_cliente INTEGER NOT NULL,
            id_grupo_de_venda INTEGER NOT NULL);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbPromoCampClientesGrupoDeVendaTemp
		SELECT * FROM json_populate_recordset(NULL::tbPromoCampClientesGrupoDeVendaTemp, p_dados);
	/*QUANDO ALGUMA CLIENTES-GRUPO DE VENDA PROMOÇÃO CAMPANHA FOR INSERIDA*/
	INSERT INTO promo_camp_clientes_grupo_de_venda
	SELECT t_temp.id_cliente, t_temp.id_grupo_de_venda,
	null as desativado, true AS modificado
	FROM tbPromoCampClientesGrupoDeVendaTemp AS t_temp
	LEFT JOIN promo_camp_clientes_grupo_de_venda AS cgv ON cgv.id_cliente = t_temp.id_cliente
	AND cgv.id_grupo_de_venda = t_temp.id_grupo_de_venda
	WHERE cgv.id_cliente IS NULL AND cgv.id_grupo_de_venda IS NULL;
	/*QUANDO ALGUM CLIENTES-GRUPO DE VENDA PROMOÇÃO CAMPANHA FOR ALTERADA*/
	UPDATE promo_camp_clientes_grupo_de_venda
		 SET id_cliente = t_temp.id_cliente,
		 id_grupo_de_venda = t_temp.id_grupo_de_venda,
		 desativado = null, modificado = true
		 FROM tbPromoCampClientesGrupoDeVendaTemp AS t_temp
		 JOIN promo_camp_clientes_grupo_de_venda cgv ON cgv.id_cliente = t_temp.id_cliente
		 AND cgv.id_grupo_de_venda = t_temp.id_grupo_de_venda
		 WHERE promo_camp_clientes_grupo_de_venda.id_grupo_de_venda = t_temp.id_grupo_de_venda
		 AND promo_camp_clientes_grupo_de_venda.id_cliente = t_temp.id_cliente;
	/*QUANDO ALGUMA CLIENTES-GRUPO DE VENDA PROMOÇÃO CAMPANHA FOR EXCLUÍDA*/ 
	UPDATE promo_camp_clientes_grupo_de_venda
	SET desativado = CURRENT_DATE
	FROM
		(SELECT cgv.id_cliente, cgv.id_grupo_de_venda
		FROM promo_camp_clientes_grupo_de_venda cgv
		LEFT JOIN tbPromoCampClientesGrupoDeVendaTemp AS t_temp
		ON t_temp.id_cliente = cgv.id_cliente
		AND t_temp.id_grupo_de_venda = cgv.id_grupo_de_venda
		WHERE (t_temp.id_cliente IS NULL AND t_temp.id_grupo_de_venda IS NULL)
		AND cgv.desativado IS NULL
		) AS desativar
		WHERE desativar.id_cliente = promo_camp_clientes_grupo_de_venda.id_cliente
		AND desativar.id_grupo_de_venda = promo_camp_clientes_grupo_de_venda.id_grupo_de_venda;
	/*Excluir tabela temporária*/
	DROP TABLE tbPromoCampClientesGrupoDeVendaTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;