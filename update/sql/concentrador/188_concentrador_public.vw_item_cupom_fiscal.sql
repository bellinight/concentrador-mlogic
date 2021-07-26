CREATE VIEW public.vw_item_cupom_fiscal AS
SELECT itemcupomfiscal.iditem        AS DFcod_item_estoque, 
       itemcupomfiscal.indice        AS DFnumero_do_item_no_cupom, 
       caixa.numeroloja              AS DFnumero_loja, 
       pdv.identificador             AS DFnumero_caixa, 
       cupomfiscal.coo               AS DFnumero_cupom_fiscal, 
       caixa.datamovimento           AS DFdata_movimento, 
       itemcupomfiscal.quantidade    AS DFquantidade_venda_bruta, 
       ( CASE WHEN itemcupomfiscal.cancelado OR cupomfiscal.cancelado 
			  THEN itemcupomfiscal.quantidade 
			  ELSE 0.0000 
       END )                         AS DFquantidade_venda_bruta_cancelada, 
       itemcupomfiscal.totalbruto    AS DFvalor_venda_bruta, 
       ( CASE WHEN itemcupomfiscal.cancelado OR cupomfiscal.cancelado 
			  THEN (itemcupomfiscal.totalbruto::numeric(18,2)) 
              ELSE 0.0000 
       END )                         AS DFvalor_venda_bruta_cancelada, 
       ( CASE WHEN ecf.tipo = 'NFCE' 
			  THEN Round(itemcupomfiscal.precocusto * itemcupomfiscal.quantidade, 2) 
              ELSE Trunc(itemcupomfiscal.precocusto * itemcupomfiscal.quantidade, 2) 
         END )                       AS DFvalor_custo_bruto, 
       ( CASE WHEN itemcupomfiscal.cancelado OR cupomfiscal.cancelado 
			  THEN ( CASE WHEN ecf.tipo = 'NFCE' 
						  THEN Round(itemcupomfiscal.precocusto * itemcupomfiscal.quantidade, 2) 
						  ELSE Trunc(itemcupomfiscal.precocusto * itemcupomfiscal.quantidade, 2) 
					 END ) 
			  ELSE 0.0000 
         END )                       AS DFvalor_custo_bruto_cancelado, 
       itemcupomfiscal.totaldesconto AS DFvalor_desconto, 
       ( CASE WHEN ecf.tipo = 'NFCE' 
		      THEN Round(itemcupomfiscal.acrescimo * itemcupomfiscal.quantidade, 2) 
              ELSE Trunc(itemcupomfiscal.acrescimo * itemcupomfiscal.quantidade, 2) 
         END )                       AS DFvalor_acrescimo, 
       aliquota.idaliquotaorigem     AS DFaliquota_origem, 
       itemcupomfiscal.preco         AS DFpreco_item, 
       aliquota.percentual           AS DFpercentual_aliquota 
FROM   itemcupomfiscal 
       INNER JOIN aliquota 
               ON itemcupomfiscal.tributacao = aliquota.id 
       INNER JOIN cupomfiscal 
               ON cupomfiscal.id = itemcupomfiscal.idcupomfiscal 
       INNER JOIN sessao 
               ON sessao.id = cupomfiscal.idsessao 
       INNER JOIN caixa 
               ON sessao.idcaixa = caixa.id 
       INNER JOIN pdv 
               ON caixa.idpdv = pdv.id 
       INNER JOIN ecf 
               ON ecf.id = pdv.idecf;
    
