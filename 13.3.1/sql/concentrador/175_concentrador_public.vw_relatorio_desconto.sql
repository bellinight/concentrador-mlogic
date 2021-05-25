DROP VIEW IF EXISTS public.vw_relatorio_desconto;
CREATE VIEW public.vw_relatorio_desconto
 AS
 SELECT rd.id,
    cf.id AS cupom_id,
    cf.ccf AS cupom_ccf,
    rd.serieecf AS cupom_serie_ecf,
    cf.totalliquido AS cupom_total_liquido,
    CASE
        WHEN cf.cancelado THEN 'CANCELADO'::text
        ELSE 'NÃO CANCELADO'::text
    END AS cupoms_tatus,
    cf.dataabertura::date AS cupom_data_abertura,
    rd.descricao AS item_descricao,
    rd.quantidade AS item_quantidade,
    COALESCE(i.preco, 0.00) AS item_preco,
    u.nome AS operador_nome,
    CASE
        WHEN sup.nome IS NULL THEN 'NÃO POSSUI'::character varying
        ELSE sup.nomereduzido
    END AS supervisor_nome,
    CASE
        WHEN rd.id_modalidade_promocional = 1 THEN 'Pack Virtual'::text
        WHEN rd.id_modalidade_promocional = 2 THEN 'Campanha'::text
        WHEN rd.id_modalidade_promocional = 3 THEN 'A partir de'::text
        WHEN rd.id_modalidade_promocional = 4 THEN 'Preço Promocional'::text
        WHEN rd.id_modalidade_promocional = 5 THEN 'Desconto Aplicado'::text
        WHEN rd.id_modalidade_promocional = 6 THEN 'Desconto Final do Cupom'::text
        WHEN rd.id_modalidade_promocional = 7 THEN 'Pré-venda'::text
        ELSE ''::text
    END AS modalidade_desconto,
    CASE
        WHEN rd.id_modalidade_promocional = ANY (ARRAY[5, 6]) THEN true
        ELSE false
    END AS desconto_manual,
    CASE
        WHEN rd.id_motivo_desconto IS NULL THEN 'NÃO POSSUI'::character varying
    ELSE md.descricao
    END AS motivo_desconto,
    rd.desconto_unitario,
    rd.desconto_total,
    rd.id_operador,
    rd.id_supervisor,
    rd.id_modalidade_promocional,
    rd.id_motivo_desconto,
    cf.cancelado AS cupom_cancelado,
    rd.id_item 
 FROM relatorio_desconto rd
 JOIN cupomfiscal cf ON cf.id = rd.id_cupom_fiscal
 JOIN item i ON i.id = rd.id_item
 JOIN usuario u ON u.id = rd.id_operador
 LEFT JOIN usuario sup ON sup.id = rd.id_supervisor
 LEFT JOIN motivo_desconto md ON md.id = rd.id_motivo_desconto
 ORDER BY (cf.dataabertura::date), rd.serieecf, cf.dataabertura, u.nome, rd.ccf, rd.id;
