/*
 * Esta função realiza a gravação dos dados do documento não fiscal.
 */
DROP FUNCTION IF EXISTS public.persiste_documento_nao_fiscal;
CREATE OR REPLACE FUNCTION public.persiste_documento_nao_fiscal (
       p_id_dados_tef_dedicado INTEGER
     , p_id_informacoes_ecf INTEGER
     , p_id_sessao INTEGER
     , p_valor NUMERIC(18,4)
     , p_coo INTEGER
     , p_gnf INTEGER
     , p_grg INTEGER
     , p_cdc INTEGER
     , p_data_hora_abertura TIMESTAMP
     , p_data_hora_fechamento TIMESTAMP
     , p_codigo INTEGER
     , p_modificado BOOLEAN
     , p_numero_loja_sessao INTEGER
     , p_id_pdv_sessao INTEGER
     , p_abertura_sessao TIMESTAMP
     , p_denominacao varchar(2)
) 
RETURNS void AS $$

DECLARE id_sessao INTEGER;
DECLARE id_dados_tef_dedicado INTEGER;
DECLARE id_documento_nao_fiscal INTEGER;
BEGIN
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  IF (id_sessao IS NULL)
  THEN
    RAISE EXCEPTION 'Nenhum sessão encontrada referente ao documento não fiscal.';
  END IF;

  id_dados_tef_dedicado = busca_dados_tef_dedicado(id_sessao, p_id_dados_tef_dedicado);
  id_documento_nao_fiscal = busca_documento_nao_fiscal(p_id_informacoes_ecf, id_sessao, p_codigo);

  IF (id_documento_nao_fiscal IS NULL)
  THEN
    INSERT INTO public.documentonaofiscal (
           iddadostefdedicado
         , idinformacoesecf
         , idsessao
         , valor
         , coo
         , gnf
         , grg
         , cdc
         , datahoraabertura
         , datahorafechamento
         , codigo
         , modificado
         , denominacao
         , md5_a2
         , md5_r06
    ) VALUES (
           id_dados_tef_dedicado
         , p_id_informacoes_ecf
         , id_sessao
         , p_valor
         , p_coo
         , p_gnf
         , p_grg
         , p_cdc
         , p_data_hora_abertura
         , p_data_hora_fechamento
         , p_codigo
         , p_modificado
         , p_denominacao
         , md5('pi')
         , md5('pi')
    );
   ELSE
    UPDATE public.documentonaofiscal
       SET iddadostefdedicado = id_dados_tef_dedicado
         , idinformacoesecf = p_id_informacoes_ecf
         , idsessao = id_sessao
         , valor = p_valor
         , coo = p_coo
         , gnf = p_gnf
         , grg = p_grg
         , cdc = p_cdc
         , datahoraabertura = p_data_hora_abertura
         , datahorafechamento = p_data_hora_fechamento
         , codigo = p_codigo
         , modificado = p_modificado
         , denominacao = p_denominacao
     WHERE id = id_documento_nao_fiscal;
    END IF;
END;
$$ LANGUAGE plpgsql;