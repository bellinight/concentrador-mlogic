/*
 * Esta função realiza a gravação dos itens devolvidos no Concentrador.
 */
DROP FUNCTION IF EXISTS public.persiste_item_devolucao; 
CREATE OR REPLACE FUNCTION public.persiste_item_devolucao(
		p_numero_loja						INTEGER
	,   p_id_pdv							INTEGER
	,	p_id_sessao 						INTEGER
	,	p_abertura_sessao					TIMESTAMP
	,	p_numero							INTEGER
	,	p_serie								INTEGER
	,	p_id_devolucao 						INTEGER
	,	p_id_item 							INTEGER
	,	p_quantidade						NUMERIC
	,	p_valor								NUMERIC
	) 
RETURNS void AS $$

DECLARE p_cod_sessao INTEGER;
DECLARE p_devolucao INTEGER;

	BEGIN
	
	p_cod_sessao = busca_sessao(p_numero_loja, p_id_pdv, p_id_sessao, p_abertura_sessao);
	SELECT id INTO p_devolucao FROM devolucao WHERE id_documento_nao_fiscal = p_id_devolucao;
	
			INSERT INTO item_devolucao
			(	id_sessao
			,	numero
			,	serie
			,   id_devolucao
			,   id_item
			, 	quantidade
			,	valor
			)
			VALUES 
			( 	p_cod_sessao
			,	p_numero
			,	p_serie
			, 	p_devolucao
			, 	p_id_item
			, 	p_quantidade
			, 	p_valor
			  );
END;
$$  LANGUAGE plpgsql;

