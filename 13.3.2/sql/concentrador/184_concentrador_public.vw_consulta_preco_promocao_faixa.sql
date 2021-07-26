DROP VIEW IF EXISTS vw_consulta_preco_promocao_faixa;
CREATE VIEW public.vw_consulta_preco_promocao_faixa AS
SELECT i.id AS cod_item_estoque
     , e.ean AS codigo_barra
     , i.nome AS descricao
     , i.preco::numeric(18,2) AS preco_venda 
     , COALESCE(tb_promocao.precopromocao::numeric(18,2), 0.00) AS preco_promocao
     , COALESCE(tb_apartir_de1.quantidade::numeric(18,2), 0.00) AS quant_apartirde1
     , COALESCE(i.preco - tb_apartir_de1.desconto::numeric(18,2), 0.00) AS preco_apartirde1
     , COALESCE(tb_apartir_de2.quantidade::numeric(18,2), 0.00) AS quant_apartirde2
     , COALESCE(i.preco - tb_apartir_de2.desconto::numeric(18,2), 0.00) AS preco_apartirde2
  FROM item i
  JOIN ean e ON e.iditem = i.id
  LEFT JOIN (
   SELECT ip.iditem
        , ip.precopromocao
     FROM itempromocao ip 
     JOIN promocao p ON p.id = ip.idpromocao 
    WHERE now() BETWEEN p.datainicio AND p.datafim
      AND ip.desativado IS NULL
      AND p.desativado IS NULL
  ) AS tb_promocao ON tb_promocao.iditem = i.id
  LEFT JOIN (
   SELECT ipa.id_item_secundario
        , fx.quantidade
        , fx.desconto
        , ROW_NUMBER () OVER (
           PARTITION BY ipa.id_item_secundario
               ORDER BY fx.quantidade) AS faixa
     FROM itempromocaolevepague ipa
     JOIN promocaolevepague pa ON pa.id_item_principal = ipa.id_item_principal
     JOIN faixaprecopromocaolevepague fx ON fx.id_item_principal = ipa.id_item_principal
    WHERE now() BETWEEN pa.datainicio AND pa.datafim
      AND ipa.desativado IS NULL
      AND pa.desativado IS NULL
      AND fx.desativado IS NULL
  ) AS tb_apartir_de1 ON tb_apartir_de1.id_item_secundario = i.id AND tb_apartir_de1.faixa = 1
  LEFT JOIN (
   SELECT ipa.id_item_secundario
        , fx.quantidade
        , fx.desconto
        , ROW_NUMBER () OVER (
           PARTITION BY ipa.id_item_secundario
               ORDER BY fx.quantidade) AS faixa
     FROM itempromocaolevepague ipa
     JOIN promocaolevepague pa ON pa.id_item_principal = ipa.id_item_principal
     JOIN faixaprecopromocaolevepague fx ON fx.id_item_principal = ipa.id_item_principal
    WHERE now() BETWEEN pa.datainicio AND pa.datafim
      AND ipa.desativado IS NULL
      AND pa.desativado IS NULL
      AND fx.desativado IS NULL
  ) AS tb_apartir_de2 ON tb_apartir_de2.id_item_secundario = i.id AND tb_apartir_de2.faixa = 2
 WHERE i.desativado IS NULL
   AND i.peso_variavel = false
   AND e.desativado IS NULL;

  
