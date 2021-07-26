----------------------------------------------------------
-- Esta função realiza a gravação dos dados de Entrega. --
----------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_entrega;
CREATE OR REPLACE FUNCTION public.persiste_entrega (
       p_ccf INTEGER
     , p_serie VARCHAR
     , p_coo INTEGER
     , p_id_cliente INTEGER
     , p_id_usuario INTEGER
     , p_cod_cpf_cnpj VARCHAR
     , p_nome_do_cliente VARCHAR
     , p_logradouro VARCHAR
     , p_bairro VARCHAR
     , p_cidade VARCHAR
     , p_referencia VARCHAR
     , p_dh_emissao TIMESTAMP
     , p_id_rota_entrega INTEGER
     , p_cep VARCHAR
     , p_sigla_uf VARCHAR
     , p_numero INTEGER
     , p_id_modalidade_frete INTEGER
     , p_id_transportadora INTEGER
     , p_telefone VARCHAR
     , p_complemento VARCHAR)
 RETURNS void AS $$

DECLARE 
  id_entrega INTEGER;
  id_cupom INTEGER;
  v_resultado RECORD;
  v_empresa RECORD;
BEGIN
  id_cupom = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom > 0) 
  THEN
    id_entrega = busca_entrega(id_cupom);
    IF (id_entrega IS NULL) 
    THEN
      INSERT INTO entrega (
             id_cupom_fiscal
           , id_cliente
           , id_usuario
           , cod_cpf_cnpj
           , nome_do_cliente
           , logradouro
           , bairro
           , cidade
           , referencia
           , dh_emissao
           , id_rota_entrega
           , cep
           , sigla_uf
           , numero
           , id_modalidade_frete
           , id_transportadora
           , telefone
           , complemento) 
      VALUES (id_cupom
           , p_id_cliente
           , p_id_usuario
           , p_cod_cpf_cnpj
           , p_nome_do_cliente
           , p_logradouro
           , p_bairro
           , p_cidade
           , p_referencia
           , p_dh_emissao
           , p_id_rota_entrega
           , p_cep
           , p_sigla_uf
           , p_numero
           , p_id_modalidade_frete
           , p_id_transportadora
           , p_telefone
           , p_complemento);
    ELSE
      UPDATE entrega
         SET id_cupom_fiscal = id_cupom
           , id_cliente = p_id_cliente
           , id_usuario = p_id_usuario
           , cod_cpf_cnpj = p_cod_cpf_cnpj
           , nome_do_cliente = p_nome_do_cliente
           , logradouro = p_logradouro
           , bairro = p_bairro
           , cidade = p_cidade
           , referencia = p_referencia
           , dh_emissao = p_dh_emissao
           , id_rota_entrega = p_id_rota_entrega
           , cep = p_cep
           , sigla_uf = p_sigla_uf
           , numero = p_numero
           , id_modalidade_frete = p_id_modalidade_frete
           , id_transportadora = p_id_transportadora
           , telefone = p_telefone
           , complemento = p_complemento
       WHERE id = id_entrega; 
    END IF;
  END IF;
END;
$$  LANGUAGE plpgsql;