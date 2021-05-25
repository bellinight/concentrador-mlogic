/*
 * Esta função realiza a gravação dos dados da recarga de celular.
 */
DROP FUNCTION IF EXISTS public.persiste_recarga_celular;
CREATE OR REPLACE FUNCTION public.persiste_recarga_celular (
       p_codigo INTEGER
     , p_ddd TEXT
     , p_numero_telefone TEXT
     , p_codigo_operadora_celular TEXT
     , p_nome_operadora TEXT
     , p_id_sessao INTEGER
     , p_modificado BOOLEAN
     , p_numero_loja_sessao INTEGER
     , p_id_pdv_sessao INTEGER
     , p_abertura_sessao TIMESTAMP
     , p_id_forma_pgto_efetuada INTEGER
     , p_codigo_rede_autorizadora TEXT
     , p_valor_pagamento DECIMAL)
RETURNS void AS $$

DECLARE id_recarga_celular INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
 id_recarga_celular = busca_recarga_celular(p_codigo, id_sessao);
 
 IF (id_sessao IS NULL)
 THEN
   RAISE EXCEPTION 'Nenhum sessão encontrada referente a recarga de celular.';
 END IF;
 
 IF (id_recarga_celular IS NULL)
 THEN
  INSERT INTO public.recargacelular (
         codigo
       , ddd
       , numerotelefone
       , codigooperadoracelular
       , nomeoperadora
       , idsessao
       , modificado
       , id_forma_pgto_efetuada
       , codigo_rede_autorizadora
       , valor_pagamento
  ) VALUES (
         p_codigo
       , p_ddd
       , p_numero_telefone
       , p_codigo_operadora_celular
       , p_nome_operadora
       , id_sessao
       , p_modificado
       , p_id_forma_pgto_efetuada
       , p_codigo_rede_autorizadora
       , p_valor_pagamento
  );
 ELSE
  UPDATE public.recargacelular
     SET codigo = p_codigo
       , ddd = p_ddd
       , numerotelefone = p_numero_telefone
       , codigooperadoracelular = p_codigo_operadora_celular
       , nomeoperadora = p_nome_operadora
       , idsessao = id_sessao
       , modificado = p_modificado
       , id_forma_pgto_efetuada = p_id_forma_pgto_efetuada
       , codigo_rede_autorizadora = p_codigo_rede_autorizadora
       , valor_pagamento = p_valor_pagamento
   WHERE id = id_recarga_celular; 
 END IF;
END;
$$  LANGUAGE plpgsql;

