CREATE VIEW public.vw_resumo_venda_itens AS
SELECT caixa.numeroloja AS dfnumero_loja
     , caixa.datamovimento AS dfdata_movimento
     , pdv.identificador AS dfnumero_pdv
     , usuario.id AS dfcodigo_operador
     , usuario.nome AS dfnome_operador
     , cfe.numero AS dfnumero_nfce
     , cf.dataabertura AS dfdata_abertura_cupom
     , cf.datafechamento AS dfdata_fechamento_cupom
     , cf.cancelado AS dfcupom_cancelado
     , CASE
            WHEN cf.id_motivo_cancelamento IS NOT NULL
            THEN mc.descricao
            ELSE NULL
       END AS dfmotivo_cancelamento_cupom
     , CASE
            WHEN cf.id_supervisor_cancelamento IS NOT NULL
            THEN (SELECT nome FROM usuario WHERE id = cf.id_supervisor_cancelamento)
            ELSE NULL
       END AS dfsupervisor_cancelamento_cupom
     , icf.iditem AS dfcodigo_item
     , item.nome AS dfdescricao_item
     , icf.cancelado AS dfitem_cancelado
     , CASE
            WHEN icf.id_motivo_cancelamento IS NOT NULL
            THEN mc.descricao
            ELSE NULL
       END AS dfmotivo_cancelamento_item
     , icf.quantidade AS dfquantidade_vendida_item
     , icf.totaldesconto AS dftotal_desconto_item
     , icf.totalliquido AS dfvalor_liquido_vendido_item
  FROM itemcupomfiscal icf
 INNER JOIN item ON item.id = icf.iditem
 INNER JOIN cupomfiscal cf ON cf.id = icf.idcupomfiscal
 INNER JOIN cupom_fiscal_eletronico cfe ON cfe.cupom_fiscal = cf.id
 INNER JOIN sessao ON sessao.id = cf.idsessao
 INNER JOIN caixa ON caixa.id = sessao.idcaixa
 INNER JOIN pdv ON pdv.id = caixa.idpdv
 INNER JOIN usuario ON usuario.id = sessao.idusuario
  LEFT JOIN motivocancelamento mc ON (mc.id = cf.id_motivo_cancelamento OR mc.id = icf.id_motivo_cancelamento);
