/*
 * Esta função tem a finalidade de persitir um item de cupom fiscal, movimentando o estoque do item.
 *
 * Regra de movimentação do estoque:
 * 
 * O item de cupom fiscal é inserido no concentrador com o campo estoqueatualizado false e o estoque é movimentado baixando a quantidade do estoque do Item. 
 * Caso o operador realize o cancelamento do cupom fiscal o sistema deverá acrescentar o valor baixado na quantidade do item.
 * Abaixo a comparação para adição no estoque:
 * 	Item já existente no banco de dados;
 * 	Cupom Fiscal Cancelado;
 * 	O campo cancelado do item esteja falso e o
 * 	campo estoqueatualizado esteja falso.
 */
DROP FUNCTION IF EXISTS public.persiste_item_cupom_fiscal;
CREATE OR REPLACE FUNCTION persiste_item_cupom_fiscal(
	p_id_item INTEGER,
	p_tributacao TEXT,
	p_id_cupom_fiscal INTEGER,
	p_id_sessao INTEGER,
	p_id_departamento INTEGER,
	p_codigo INTEGER,
	p_indice INTEGER,
	p_preco DECIMAL(18,4),
	p_preco_custo DECIMAL(18,4), 
	p_quantidade DECIMAL(18,4), 
	p_cancelado BOOLEAN, 
	p_cesta_basica BOOLEAN, 
	p_desconto DECIMAL(18,4), 
	p_acrescimo DECIMAL(18,4), 
	p_estoque_atualizado BOOLEAN, 
	p_modificado BOOLEAN, 
	p_total_desconto DECIMAL(18,4), 
	p_total_bruto DECIMAL(18,4), 
	p_total_liquido DECIMAL(18,4), 
	p_ccf INTEGER, 
	p_serie_ecf TEXT,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
	p_motivo_cancelamento INTEGER,
    p_coo INTEGER,
	p_id_supervisor_cancelamento INTEGER,
	p_id_supervisor_desconto INTEGER) 
RETURNS void AS $$

DECLARE id_item_cupom INTEGER;
DECLARE id_cupom_fiscal INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_item_cupom = busca_item_cupom_fiscal(p_codigo, p_ccf, p_serie_ecf, p_coo);
 id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
 
 IF (id_item_cupom > 0) THEN

    UPDATE itemcupomfiscal
       SET  cancelado = p_cancelado,
            desconto = p_desconto,
            quantidade = p_quantidade,
            preco = p_preco,
            totaldesconto = p_total_desconto,
            totalbruto = p_total_bruto,
            totalliquido = p_total_liquido,
            id_motivo_cancelamento = p_motivo_cancelamento,
            id_supervisor_cancelamento = p_id_supervisor_cancelamento,
            id_supervisor_desconto = p_id_supervisor_desconto
    WHERE id = id_item_cupom;

 ELSE
    id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
    INSERT INTO itemcupomfiscal
       (iditem,
       tributacao,
       idcupomfiscal,
       idsessao,
       iddepartamento,
       codigo,
       indice,
       preco,
       precocusto,
       quantidade,
       cancelado,
       cestabasica,
       desconto,
       acrescimo,
       estoqueatualizado,
       modificado,
       totaldesconto,
       totalbruto,
       totalliquido,
       id_motivo_cancelamento,
       md5_r05,
	   id_supervisor_cancelamento,
	   id_supervisor_desconto)
    VALUES      (p_id_item,
       p_tributacao,
       id_cupom_fiscal,
       id_sessao,
       p_id_departamento,
       p_codigo,
       p_indice,
       p_preco,
       p_preco_custo,
       p_quantidade,
       p_cancelado,
       p_cesta_basica,
       p_desconto,
       p_acrescimo,
       p_estoque_atualizado,
       p_modificado,
       p_total_desconto,
       p_total_bruto,
       p_total_liquido,
       p_motivo_cancelamento,
       md5('pi'),
	   p_id_supervisor_cancelamento,
	   p_id_supervisor_desconto);     
 END IF;
END;
$$  LANGUAGE plpgsql;