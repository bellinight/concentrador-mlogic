/*
 * Esta função realiza a gravação dos dados do correspondente bancário.
 */
DROP FUNCTION IF EXISTS public.persiste_correspondente_bancario;
CREATE OR REPLACE FUNCTION public.persiste_correspondente_bancario(
	p_id_sessao INTEGER,
	p_codigo INTEGER,
	p_nome_cedente TEXT,
	p_valor_desconto NUMERIC(18,4),
	p_valor_acrescimo NUMERIC(18,4),
	p_valor_pago NUMERIC(18,4),
	p_data_vencimento TIMESTAMP,
	p_tipo_documento TEXT,
	p_modificado BOOLEAN,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP) 
RETURNS void AS $$

DECLARE id_correspondente_bancario INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
 id_correspondente_bancario = busca_correspondente_bancario(id_sessao, p_codigo);
          
 IF (id_correspondente_bancario IS NULL) THEN
    
  INSERT INTO correspondentebancario
   (idsessao,
   codigo,
   nomecedente,
   valordesconto,
   valoracrescimo,
   valorpago,
   datavencimento,
   tipodocumento,
   modificado)
  VALUES (id_sessao,
   p_codigo,
   p_nome_cedente,
   p_valor_desconto,
   p_valor_acrescimo,
   p_valor_pago,
   p_data_vencimento,
   p_tipo_documento,
   p_modificado); 
 END IF;
END;
$$  LANGUAGE plpgsql;

