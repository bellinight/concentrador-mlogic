CREATE VIEW public.vw_reducaoz AS 
 SELECT ( SELECT empresa.id
           FROM empresa
             JOIN configuracao ON configuracao.chave::text = 'codigo.empresa.padrao'::text
          WHERE empresa.id = configuracao.valor::integer
         LIMIT 1) AS dfnumero_loja,
    pdv.identificador AS dfnumero_caixa,
    reducaoz.datamovimento AS dfdata_movimento,
        CASE
            WHEN (( SELECT min(cupomfiscal.coo) AS min
               FROM cupomfiscal
              WHERE cupomfiscal.serieecf::text = ecf.numerofabricacao::text AND to_char(reducaoz.datamovimento::timestamp with time zone, 'YYYY-MM-DD'::text) = to_char(cupomfiscal.dataabertura, 'YYYY-MM-DD'::text))) = 0 THEN reducaoz.coo
            WHEN (( SELECT min(cupomfiscal.coo) AS min
               FROM cupomfiscal
              WHERE cupomfiscal.serieecf::text = ecf.numerofabricacao::text AND to_char(reducaoz.datamovimento::timestamp with time zone, 'YYYY-MM-DD'::text) = to_char(cupomfiscal.dataabertura, 'YYYY-MM-DD'::text))) IS NULL THEN reducaoz.coo
            ELSE ( SELECT min(cupomfiscal.coo) AS min
               FROM cupomfiscal
              WHERE cupomfiscal.serieecf::text = ecf.numerofabricacao::text AND to_char(reducaoz.datamovimento::timestamp with time zone, 'YYYY-MM-DD'::text) = to_char(cupomfiscal.dataabertura, 'YYYY-MM-DD'::text))
        END AS dfcupom_inicial,
    reducaoz.coo AS dfcupom_final,
    reducaoz.crz AS dfcontador_reducaoz,
    reducaoz.cro AS dfcontador_reinicio_operacao,
    reducaoz.vendabrutadiaria - tbtemp_frete.total_frete AS dfvalor_total_cupom,
    ecf.numerofabricacao AS dfnumero_fabricacao,
    reducaoz.totalizadorgeral - reducaoz.vendabrutadiaria AS dfgt_inicial,
    reducaoz.totalizadorgeral AS dfgt_final,
    COALESCE(tbtmp_cancelamento.totalcancelamentos, 0::numeric) AS dfcancelamentos,
    COALESCE(tbtemp_desconto.totaldesconto, 0::numeric) AS dfdescontos,
    ecf.tipo AS dftipo_ecf
   FROM reducaoz
     JOIN ecf ON ecf.id = reducaoz.idinformacoesecf
     JOIN pdv ON pdv.idecf = ecf.id
     JOIN sessao ON sessao.idpdv = pdv.id AND sessao.id = reducaoz.idsessao
     LEFT JOIN ( SELECT cupomfiscal.serieecf,
            caixa.datamovimento,
            SUM(itemcupomfiscal.totalbruto) AS totalcancelamentos
           FROM itemcupomfiscal
             JOIN cupomfiscal ON cupomfiscal.id = itemcupomfiscal.idcupomfiscal
             JOIN sessao sessao_1 ON cupomfiscal.idsessao = sessao_1.id
             JOIN caixa ON caixa.id = sessao_1.idcaixa
          WHERE itemcupomfiscal.cancelado = true OR cupomfiscal.cancelado = true
          GROUP BY cupomfiscal.serieecf, caixa.datamovimento) tbtmp_cancelamento ON tbtmp_cancelamento.serieecf::text = ecf.numerofabricacao::text AND tbtmp_cancelamento.datamovimento = reducaoz.datamovimento
     LEFT JOIN ( SELECT cupomfiscal.serieecf,
            caixa.datamovimento,
            SUM(itemcupomfiscal.totaldesconto) AS totaldesconto
           FROM itemcupomfiscal
             JOIN cupomfiscal ON cupomfiscal.id = itemcupomfiscal.idcupomfiscal
             JOIN sessao sessao_1 ON cupomfiscal.idsessao = sessao_1.id
             JOIN caixa ON caixa.id = sessao_1.idcaixa
          WHERE itemcupomfiscal.cancelado = false AND cupomfiscal.cancelado = false
          GROUP BY cupomfiscal.serieecf, caixa.datamovimento) tbtemp_desconto 
             ON tbtemp_desconto.serieecf::text = ecf.numerofabricacao::text AND tbtemp_desconto.datamovimento = reducaoz.datamovimento
     LEFT JOIN (SELECT cupomfiscal.serieecf,
                       caixa.datamovimento,
                       COALESCE(SUM(cupomfiscal.frete::numeric), 0) AS total_frete
                  FROM cupomfiscal
                  JOIN sessao sessao ON cupomfiscal.idsessao = sessao.id
                  JOIN caixa ON caixa.id = sessao.idcaixa
                 WHERE cupomfiscal.cancelado = false
              GROUP BY cupomfiscal.serieecf, caixa.datamovimento) tbtemp_frete
                 ON tbtemp_frete.serieecf::text = ecf.numerofabricacao::text AND tbtemp_frete.datamovimento = reducaoz.datamovimento;