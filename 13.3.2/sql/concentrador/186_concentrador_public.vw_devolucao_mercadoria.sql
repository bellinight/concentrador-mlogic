CREATE OR REPLACE VIEW public.vw_devolucao_mercadoria AS
SELECT item.numero AS dfnumero_cupom
     , item.serie AS dfserie_cupom
     , d.data_devolucao AS dfdata
     , item.id_item AS dfcodigo_item
     , item.quantidade AS dfquantidade
     , item.valor AS dfvalor_total
     , d.cpf_cliente AS dfcpf_cliente
     , d.loja AS dfempresa
  FROM devolucao d
 INNER JOIN item_devolucao item
    ON d.id = item.id_devolucao
 WHERE 1 = 1;