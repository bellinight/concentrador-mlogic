-- Esta função realiza a gravação da Devolucao no Concentrador
DROP FUNCTION IF EXISTS public.persiste_devolucao;
CREATE OR REPLACE FUNCTION public.persiste_devolucao(
    p_id_sessao INTEGER
  , p_abertura_sessao TIMESTAMP
  , p_numero_nfce INTEGER
  , p_serie INTEGER
  , p_id_documento_nao_fiscal INTEGER
  , p_cpf_cliente VARCHAR
  , p_motivo VARCHAR
  , p_data_devolucao TIMESTAMP
  , p_valor_total NUMERIC
  , p_loja INTEGER
  , p_id_fiscal INTEGER
  , p_id_informacoes_ecf INTEGER
  , p_id_pdv INTEGER) 
RETURNS void AS $$
DECLARE v_id_sessao INTEGER;
DECLARE v_id_documento_nao_fiscal INTEGER;
DECLARE v_id_devolucao INTEGER;
BEGIN  
  v_id_sessao = busca_sessao(p_loja, p_id_pdv, p_id_sessao, p_abertura_sessao);
  
  IF (v_id_sessao IS NULL) THEN
    RAISE EXCEPTION 'Sessão não encontrada para a devolução da NFCe %', p_numero_nfce;
  END IF;  

  v_id_documento_nao_fiscal = busca_documento_nao_fiscal(p_id_informacoes_ecf, v_id_sessao, p_id_documento_nao_fiscal);
  v_id_devolucao = busca_devolucao(v_id_documento_nao_fiscal);

  IF (v_id_devolucao IS NULL)
  THEN
    INSERT INTO devolucao (
           id_sessao
         , numero
         , serie
         , id_documento_nao_fiscal
         , cpf_cliente
         , motivo
         , data_devolucao
         , valor_total
         , loja
         , id_fiscal) 
    VALUES ( 
           v_id_sessao
         , p_numero_nfce
         , p_serie
         , p_id_documento_nao_fiscal
         , p_cpf_cliente
         , p_motivo
         , p_data_devolucao
         , p_valor_total
         , p_loja
         , p_id_fiscal);
  ELSE
    UPDATE devolucao SET 
           id_sessao = v_id_sessao
         , numero = p_numero_nfce
         , serie = p_serie
         , id_documento_nao_fiscal = p_id_documento_nao_fiscal
         , cpf_cliente = p_cpf_cliente
         , motivo = p_motivo
         , data_devolucao = p_data_devolucao
         , valor_total = p_valor_total
         , loja = p_loja
         , id_fiscal = p_id_fiscal
     WHERE id = v_id_devolucao;
  END IF;
END;
$$  LANGUAGE plpgsql;