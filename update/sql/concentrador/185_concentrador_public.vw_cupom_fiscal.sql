CREATE VIEW public.vw_cupom_fiscal AS
SELECT 
caixa.numeroloja AS DFnumero_loja, 
pdv.identificador AS DFnumero_caixa, 
cupomfiscal.coo AS DFnumero_cupom, 
cupomfiscal.cancelado AS DFcancelado,
caixa.datamovimento AS DFdata_movimento,
cupomfiscal.idcliente AS DFcod_cliente
FROM cupomfiscal
INNER JOIN sessao ON sessao.id = cupomfiscal.idsessao
INNER JOIN caixa ON caixa.id = sessao.idcaixa
INNER JOIN pdv ON caixa.idpdv = pdv.id;

