/*
 * Esta função realiza a gravação dos dados da redução Z.
 */
DROP FUNCTION IF EXISTS public.persiste_reducao_z;
CREATE OR REPLACE FUNCTION public.persiste_reducao_z(
	p_id_informacoes_ecf INTEGER,
	p_id_sessao INTEGER,
	p_crz INTEGER,
	p_coo INTEGER,
	p_cro INTEGER,
	p_data_movimento DATE,
	p_data_emissao TIMESTAMP,
	p_venda_bruta_diaria NUMERIC(18,4),
	p_totalizador_geral NUMERIC(18,4),
	p_cancelmanetos NUMERIC(18,4),
	p_descontos NUMERIC(18,4),
	p_codigo INTEGER,
	p_modificado BOOLEAN,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP) 
RETURNS void AS $$

DECLARE id_reducao_z INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_reducao_z = busca_reducao_z(p_id_informacoes_ecf, p_data_movimento);       
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao); 
 
 IF (id_reducao_z IS NULL) THEN
  
  INSERT INTO reducaoz
   (idinformacoesecf,
   idsessao,
   crz,
   coo,
   cro,
   datamovimento,
   dataemissao,
   vendabrutadiaria,
   totalizadorgeral,
   cancelmanetos,
   descontos,
   codigo,
   modificado,
   md5_r02)
  VALUES (p_id_informacoes_ecf,
   id_sessao,
   p_crz,
   p_coo,
   p_cro,
   p_data_movimento,
   p_data_emissao,
   p_venda_bruta_diaria,
   p_totalizador_geral,
   p_cancelmanetos,
   p_descontos,
   p_codigo,
   p_modificado,
   md5('pi'));
   
  ELSE
  
  UPDATE reducaoz SET
   idinformacoesecf = p_id_informacoes_ecf,
   idsessao = id_sessao,
   crz = p_crz,
   coo = p_coo,
   cro = p_cro,
   datamovimento = p_data_movimento,
   dataemissao = p_data_emissao,
   vendabrutadiaria = p_venda_bruta_diaria,
   totalizadorgeral = p_totalizador_geral,
   cancelmanetos = p_cancelmanetos,
   descontos = p_descontos,
   codigo = p_codigo,
   modificado = p_modificado,
   md5_r02 = md5('pi')
   WHERE id = id_reducao_z;
  
 END IF;
END;
$$  LANGUAGE plpgsql;

