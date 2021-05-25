/*
* View refatorada para facilitar o processo de importação das vendas/recargas/pagamentos para o (ERP).
* Atualizada em 13/05/2019.
*/
DO $$
DECLARE v_select_comum VARCHAR;
DECLARE v_select_tef VARCHAR;
DECLARE v_select_venda VARCHAR;
DECLARE v_extras_venda VARCHAR;
DECLARE v_extras_venda_rede_geral VARCHAR;
DECLARE v_extras_venda_rede_corban VARCHAR;
DECLARE v_select_recarga VARCHAR;
DECLARE v_select_corban VARCHAR;
--DECLARE v_select_troco_solidario VARCHAR;
BEGIN

v_extras_venda := '
     , dadostefdedicado.bandeira AS dfcod_bandeira    
     , NULL::INT AS dfnumero_ccf
     , NULL::INT AS dfid_cupom
     , NULL::INT AS dfid_finalizacao
     , NULL::INT AS dfident_cliente
	 , NULL::INT AS dfcod_cliente_convenio
	 , NULL::INT AS dfcod_cliente_conveniado
     , NULL::VARCHAR(6) AS dfnumero_cheque
     , NULL::DATE AS dfdata_cheque	    
     , NULL::VARCHAR(70) AS dfbanda_magnetica
     , NULL::VARCHAR(4) AS dfbanco
     , NULL::VARCHAR(4) AS dfagencia
     , NULL::VARCHAR(12) AS dfconta_corrente ';

v_extras_venda_rede_geral := '
	, dadostefdedicado.rede AS dfrede
';

v_extras_venda_rede_corban := '
	, NULL::VARCHAR(10) AS dfrede
';

v_select_comum := '
SELECT sessao.id AS dfid_sessao
     , sessao.fechado AS dfsessao_fechada
	 , caixa.datamovimento AS dfdata_movimento
     , sessao.numeroloja AS dfcod_empresa 
     , sessao.idusuario AS dfcod_operador
     , usuario.nome AS dfnome_operador
     , pdv.identificador AS dfnumero_caixa ';	

v_select_tef := '
     , NULL::date AS dfdata_parcela 
     , dadostefdedicado.nsusitef AS dfnsu
     , dadostefdedicado.nsuhostautorizador AS dfnsu_host
     , dadostefdedicado.codigoautorizacao AS dfcodigo_autorizacao
     , dadostefdedicado.numeroparcelas AS dfnum_parcelas
     , dadostefdedicado.datahoratransacao AS dfdata_transacao
     , dadostefdedicado.bin AS dfbin_cartao
     , dadostefdedicado.codigo_estabelecimento AS dfcod_estabelecimento
     , dadostefdedicado.formapagamento AS dfcod_pagto_tef
     , dadostefdedicado.codigo_ident_carteira_digital AS dfcod_ident_carteira_digital
     , dadostefdedicado.descricao_carteira_digital AS dfdescricao_carteira_digital
     , dadostefdedicado.codigo_psp_carteira_digital AS dfcod_psp_carteira_digital';

/* VENDA DE CUPOM */
v_select_venda := CONCAT(v_select_comum, '
     , cupomfiscal.coo AS dfnumero_cupom
     , cupomfiscal.datafechamento AS dfdata_venda
     , formapagamentoefetuada.valor AS dfvalor
     , cupomfiscal.totalliquido AS dfvalor_liquido_cupom
     , formapagamentoefetuada.valor_recebido AS dfvalor_recebido
     , formapagamentoefetuada.idforma AS dfcod_finalizacao
     , formapagamento.nome AS dffinalizacao
     , cupomfiscal.cancelado AS dfcancelado
     , CAST(''V'' AS CHAR(1)) AS dftipo_cupom
	 , NULL::VARCHAR(15) AS dfrede_concessionaria
     , NULL::VARCHAR(11) AS dfcod_concessionaria
     , NULL::VARCHAR(50) AS dfnome_concessionaria
     , NULL::VARCHAR(13) AS dftelefone_recarga '
	 , v_select_tef, '
	 , pagamentotef.rede AS dfrede
     , pagamentotef.bandeira AS dfcod_bandeira	    
     , cupomfiscal.ccf AS dfnumero_ccf
     , cupomfiscal.id AS dfid_cupom
     , formapagamentoefetuada.id AS dfid_finalizacao
     , formapagamentoefetuada.idcliente AS dfident_cliente
	 , formapagamentoefetuada.codigo_convenio AS dfcod_cliente_convenio
	 , formapagamentoefetuada.codigo_conveniado AS dfcod_cliente_conveniado
     , pagamentotef.numerocheque AS dfnumero_cheque
     , pagamentotef.datavencimento AS dfdata_cheque	    
     , pagamentotef.cmc7 AS dfbanda_magnetica
     , pagamentotef.banco AS dfbanco
     , pagamentotef.agencia AS dfagencia
     , pagamentotef.contacorrente AS dfconta_corrente
		
FROM formapagamentoefetuada
     INNER JOIN formapagamento ON formapagamentoefetuada.idforma = formapagamento.id
     INNER JOIN cupomfiscal ON formapagamentoefetuada.idcupom = cupomfiscal.id
     INNER JOIN sessao ON sessao.id = cupomfiscal.idsessao
     INNER JOIN caixa ON caixa.id = sessao.idcaixa
     INNER JOIN pdv ON caixa.idpdv = pdv.id
     INNER JOIN usuario ON usuario.id = sessao.idusuario
     LEFT JOIN pagamentotef ON pagamentotef.idformapagamentoefetuada = formapagamentoefetuada.id
     LEFT JOIN dadostefdedicado ON pagamentotef.id = dadostefdedicado.idpagamentotef ');

/* RECARGA DE CELULAR */
v_select_recarga := CONCAT(v_select_comum, '
     , documentonaofiscal.coo AS dfnumero_cupom
     , documentonaofiscal.datahorafechamento AS dfdata_venda
     , rc.valor_pagamento AS dfvalor
     , rc.valor_pagamento AS dfvalor_liquido_cupom
     , rc.valor_pagamento AS dfvalor_recebido
     , rc.id_forma_pgto_efetuada AS dfcod_finalizacao
     , fp.nome AS dffinalizacao
     , FALSE::BOOLEAN AS dfcancelado
     , CAST(''R'' AS CHAR(1)) AS dftipo_cupom
	 , rc.codigo_rede_autorizadora AS dfrede_concessionaria
     , rc.codigooperadoracelular AS dfcod_concessionaria
     , rc.nomeoperadora AS dfnome_concessionaria
     , rc.ddd || rc.numerotelefone AS dftelefone_recarga ' 
     , v_select_tef
	 , v_extras_venda_rede_geral
     , v_extras_venda
     , 'FROM recargacelular rc 
	    INNER JOIN dadostefdedicado ON dadostefdedicado.idrecargacelular = rc.id
	    INNER JOIN documentonaofiscal ON documentonaofiscal.iddadostefdedicado = dadostefdedicado.id
	    INNER JOIN sessao ON sessao.id = rc.idsessao
	    INNER JOIN caixa ON caixa.id = sessao.idcaixa
	    INNER JOIN pdv ON caixa.idpdv = pdv.id 
	    INNER JOIN usuario ON usuario.id = sessao.idusuario 
	    LEFT JOIN formapagamento fp ON fp.id = rc.id_forma_pgto_efetuada ');

/* CORRESPONDENTE BANCARIO */
v_select_corban := CONCAT(v_select_comum, '
     , documentonaofiscal.coo AS dfnumero_cupom
     , documentonaofiscal.datahorafechamento AS dfdata_venda  
     , cb.valorpago AS dfvalor
     , cb.valorpago AS dfvalor_liquido_cupom
     , cb.valorpago AS dfvalor_recebido
     , CASE WHEN dadostefdedicado.formapagamento = ''98'' THEN 1::INT
			ELSE NULL
		END AS dfcod_finalizacao
	 ,	CASE WHEN dadostefdedicado.formapagamento = ''98'' THEN ''Dinheiro''
			ELSE NULL 
		END AS dffinalizacao
     , FALSE::BOOLEAN AS dfcancelado
     , CAST(''P'' AS CHAR(1)) AS dftipo_cupom
	 , dadostefdedicado.rede AS dfrede_concessionaria
     , NULL::VARCHAR(11) AS dfcod_concessionaria
     , NULL::VARCHAR(50) AS dfnome_concessionaria
     , NULL::VARCHAR(13) AS dftelefone_recarga '
     , v_select_tef
	 , v_extras_venda_rede_corban
     , v_extras_venda
     , 'FROM correspondentebancario cb 
	    INNER JOIN dadostefdedicado ON dadostefdedicado.idcorrespondentebancario = cb.id
	    INNER JOIN documentonaofiscal ON documentonaofiscal.iddadostefdedicado = dadostefdedicado.id
	    INNER JOIN sessao ON sessao.id = cb.idsessao
	    INNER JOIN caixa ON caixa.id = sessao.idcaixa
	    INNER JOIN pdv ON caixa.idpdv = pdv.id 
	    INNER JOIN usuario ON usuario.id = sessao.idusuario ');
		
/* TROCO SOLIDÁRIO 
v_select_troco_solidario := CONCAT(v_select_comum, '
	 , cupomfiscal.coo AS dfnumero_cupom
     , cupomfiscal.datafechamento AS dfdata_venda
	 , troco_solidario.valor AS dfvalor
	 , formapagamentoefetuada.idforma AS dfcod_finalizacao
	 , CAST(''D'' AS CHAR(1)) AS dftipo_cupom'
	 , v_select_tef
	 , v_extras_venda_rede_geral
     , v_extras_venda
	 , 'FROM troco_solidario
		LEFT JOIN entidade_destino ON entidade_destino.id = troco_solidario.id_entidade
		LEFT JOIN cupomfiscal ON cupomfiscal.id = troco_solidario.id_cupom
		LEFT JOIN formapagamentoefetuada ON formapagamentoefetuada.idcupom = cupomfiscal.id
		LEFT JOIN formapagamento ON formapagamento.id = formapagamentoefetuada.idforma
		LEFT JOIN sessao ON sessao.id = cupomfiscal.idsessao
		WHERE formapagamento.id = 1');*/

/* EXECUTANDO O SCRIPT COMPLETO */
EXECUTE CONCAT(
	'DROP VIEW IF EXISTS vw_finalizacao;
	CREATE OR REPLACE VIEW public.vw_finalizacao AS',
	v_select_venda, 'UNION ALL', v_select_recarga, 'UNION ALL', v_select_corban
);
END
$$;