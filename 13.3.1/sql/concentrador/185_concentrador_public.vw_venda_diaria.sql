CREATE OR REPLACE VIEW public.vw_venda_diaria AS
SELECT
       caixa.numeroloja AS DFnumero_loja
     , caixa.datamovimento AS DFdata_movimento
     , itemcupomfiscal.iditem AS DFcodigo_item
     , SUM(itemcupomfiscal.quantidade) AS DFquantidade_venda
     , SUM(itemcupomfiscal.totalliquido) AS DFvalor_venda_liquido
     , SUM(round(itemcupomfiscal.precocusto * itemcupomfiscal.quantidade,2)) AS DFvalor_custo_bruto
     , CASE
         WHEN ecf.tipo <> 'NFCE'
         THEN round((SUM(itemcupomfiscal.totalliquido) * aliquota.percentual) / 100::numeric, 2)
         ELSE round(SUM(itemcupomfiscal.totalliquido) * (1 - (round(item.percentual_reducao / 100::numeric, 4))) * round((aliquota.percentual / 100::numeric), 4), 2)
       END AS DFvalor_icms
FROM itemcupomfiscal
  JOIN item ON item.id = itemcupomfiscal.iditem 
  JOIN aliquota ON itemcupomfiscal.tributacao::text = aliquota.id::text
  JOIN cupomfiscal ON cupomfiscal.id = itemcupomfiscal.idcupomfiscal
  JOIN sessao ON sessao.id = cupomfiscal.idsessao
  JOIN caixa ON sessao.idcaixa = caixa.id
  JOIN pdv ON caixa.idpdv = pdv.id 
  JOIN ecf ON ecf.id = pdv.idecf
WHERE itemcupomfiscal.cancelado = false
 AND cupomfiscal.cancelado = false
GROUP BY caixa.numeroloja, caixa.datamovimento , iditem, aliquota.percentual, item.percentual_reducao, ecf.tipo;