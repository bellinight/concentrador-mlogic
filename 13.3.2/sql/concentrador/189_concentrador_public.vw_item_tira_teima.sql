DROP VIEW IF EXISTS vw_item_tira_teima;
CREATE VIEW public.vw_item_tira_teima AS 
( SELECT DISTINCT ean.ean, item.nome, (item.preco::numeric(18,2)) AS preco
   FROM item
   JOIN ean ON ean.iditem = item.id
  WHERE NOT (item.id IN ( SELECT itempromocao.iditem
      FROM itempromocao
   JOIN promocao ON itempromocao.idpromocao = promocao.id
  WHERE promocao.datafim >= now()
    AND itempromocao.desativado is null 
    AND promocao.desativado is null))
  AND item.desativado is null
  AND item.peso_variavel = false
  AND ean.desativado is null
  ORDER BY ean.ean, item.nome, ((item.preco::numeric(18,2))))
UNION 
( SELECT DISTINCT ean.ean, item.nome, (itempromocao.precopromocao::numeric(18,2)) AS preco
   FROM itempromocao
   JOIN promocao ON itempromocao.idpromocao = promocao.id
   JOIN item ON item.id = itempromocao.iditem
   JOIN ean ON ean.iditem = item.id
  WHERE promocao.datafim >= now() 
    AND promocao.desativado is null
    AND itempromocao.desativado is null
    AND item.desativado is null
    AND item.peso_variavel = false
    AND ean.desativado is null
  ORDER BY ean.ean, item.nome, ((itempromocao.precopromocao::numeric(18,2))));

  
