CREATE OR REPLACE VIEW public.vw_relatorio_promocoes_scanntech AS
SELECT cf.id AS cupom_id
     , cf.ccf AS cupom_nfce
     , cf.serieecf AS cupom_serie_ecf
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
     , ppv.descricao AS promocao_nome
FROM cupomfiscal cf
JOIN cupom_fiscal_eletronico cfe ON cfe.cupom_fiscal = cf.id
JOIN itemcupomfiscal icf ON icf.idcupomfiscal = cf.id
JOIN item i ON i.id = icf.iditem
JOIN ean e ON e.iditem = i.id
JOIN promocao_pack_virtual ppv ON ppv.id_item = i.id
WHERE ppv.pertence_scanntech 
  AND icf.totaldesconto > 0::numeric 
  AND (upper(cfe.situacao::text) = ANY (ARRAY['Z'::text, 'G'::text, 'L'::text]))
ORDER BY cfe.dh_emissao;