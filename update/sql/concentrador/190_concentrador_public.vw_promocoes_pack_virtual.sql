CREATE OR REPLACE VIEW public.vw_promocoes_pack_virtual AS
SELECT icd.id_promocao_retaguarda AS promocao_id
     , icd.nome_promocao_retaguarda AS promocao_nome
     , icd.pertence_scanntech AS promocao_scanntech
     , cf.id AS cupom_id
     , cfe.numero AS cupom_nfce
     , cf.serieecf AS cupom_serie
     , CASE upper(cfe.situacao::text)
           WHEN 'L'::text THEN 'CANCELADO'::text
           WHEN 'G'::text THEN 'CONTINGÊNCIA'::text
           WHEN 'Z'::text THEN 'EMITIDO'::text
           ELSE NULL::text
       END AS cupom_status
     , cfe.dh_emissao AS cupom_data_emissao
     , icf.iditem AS item_id
     , icf.preco AS item_preco
     , icf.quantidade AS item_quantidade
     , icf.totaldesconto AS item_total_desconto
     , icf.totalliquido AS item_total_liquido
     , i.descricao AS item_descricao
     , e.ean AS item_ean
  FROM cupomfiscal cf
  JOIN cupom_fiscal_eletronico cfe ON cfe.cupom_fiscal = cf.id
  JOIN itemcupomfiscal icf ON icf.idcupomfiscal = cf.id
  JOIN item i ON i.id = icf.iditem
  JOIN ean e ON e.iditem = i.id
  JOIN item_cupom_desconto icd ON icd.id_item_cupom_fiscal = icf.id
 WHERE (upper(cfe.situacao::text) = ANY (ARRAY['Z'::text, 'G'::text, 'L'::text]))
   AND icd.id_modalidade = 1
 ORDER BY cfe.dh_emissao;