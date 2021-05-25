CREATE VIEW public.vw_resumo_aliquotas AS
SELECT 
caixa.numeroloja AS DFnumero_loja,
sessao.idpdv as DFnumero_caixa, 
caixa.datamovimento as DFdata_movimento,
aliquota.idaliquotaorigem AS DFidentificador_aliquota,
SUM(itemcupomfiscal.totalliquido)::numeric(18,2) AS DFvalor_base, 
aliquota.percentual AS DFpercentual_aliquota,
( CASE WHEN (SELECT ecf.tipo FROM pdv INNER JOIN ecf ON pdv.idecf = ecf.id
			 WHERE pdv.id = sessao.idpdv LIMIT 1) = 'NFCE'
	 THEN round((SUM(itemcupomfiscal.totalliquido) * aliquota.percentual) / 100,2) 
	 ELSE trunc((SUM(itemcupomfiscal.totalliquido) * aliquota.percentual) / 100,2) 
END ) AS DFvalor_icms,
SUM(itemcupomfiscal.totalbruto)::numeric(18,2) AS DFtotal_bruto, 
0.00  AS DFtotal_cancelamentos, 
0.00 AS DFtotal_desconto
FROM itemcupomfiscal 
INNER JOIN aliquota ON itemcupomfiscal.tributacao = aliquota.id 
INNER JOIN cupomfiscal ON cupomfiscal.id = itemcupomfiscal.idcupomfiscal
INNER JOIN sessao ON sessao.id = cupomfiscal.idsessao 
INNER JOIN caixa ON caixa.id = sessao.idcaixa 
WHERE itemcupomfiscal.cancelado = 'false' 
AND cupomfiscal.cancelado = 'false'
GROUP  BY aliquota.idaliquotaorigem,aliquota.percentual,sessao.idpdv, caixa.datamovimento, caixa.numeroloja;


