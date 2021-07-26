/*
 * Esta função realiza a gravação dos dados do suprimento.
 */ 
DROP FUNCTION IF EXISTS public.persiste_suprimento;
CREATE OR REPLACE FUNCTION public.persiste_suprimento(
	p_id_informacoes_ecf INTEGER,
	p_id_sessao INTEGER,
	p_valor NUMERIC(18,4),
	p_coo INTEGER,
	p_gnf INTEGER,
	p_data_hora_emissao TIMESTAMP,
	p_codigo INTEGER,
	p_modificado BOOLEAN,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
	p_denominacao varchar(2),
	p_id_motivo INTEGER,
	p_id_supervisor INTEGER) 
RETURNS void AS $$

DECLARE id_suprimento INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_suprimento = busca_suprimento(p_id_informacoes_ecf, p_coo, p_gnf);
                
 IF (id_suprimento IS NULL) THEN
    
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  INSERT INTO suprimento
   (idinformacoesecf,
   idsessao,
   valor,
   coo,
   gnf,
   datahoraemissao,
   codigo,
   modificado,
   denominacao,
   md5_r06,
   id_motivo,
   id_supervisor)
  VALUES (p_id_informacoes_ecf,
   id_sessao,
   p_valor,
   p_coo,
   p_gnf,
   p_data_hora_emissao,
   p_codigo,
   p_modificado,
   p_denominacao,
   md5('pi'),
   p_id_motivo,
   p_id_supervisor);
 END IF;
END;
$$  LANGUAGE plpgsql;

