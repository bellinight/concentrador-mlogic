CREATE VIEW public.vw_show_case_item AS
SELECT item.id AS DFcod_item_estoque,
  LEFT (item.nome, 20) AS DFdescricao,
       unidade.sigla AS DFdescricaoUnidade,
 TRUNC (item.preco,2) AS DFpreco_venda
  FROM item
  JOIN unidade ON unidade.id = item.unidade
 WHERE item.peso_variavel = true;