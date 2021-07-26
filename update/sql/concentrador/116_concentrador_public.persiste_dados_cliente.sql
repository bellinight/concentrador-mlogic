-------------------------------------------------------------------------------------------------------
-- Esta função realiza a gravação dos dados do Cliente que não está cadastrado no banco do Director. --
-------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_dados_cliente;
CREATE OR REPLACE FUNCTION public.persiste_dados_cliente (
    p_nome VARCHAR
  , p_ccf INTEGER
  , p_cpf_cnpj VARCHAR
  , p_logradouro VARCHAR
  , p_numero INTEGER
  , p_bairro VARCHAR
  , p_codigo_municipio INTEGER
  , p_nome_municipio VARCHAR
  , p_sigla_uf VARCHAR
  , p_cep VARCHAR
  , p_complemento VARCHAR
  , p_telefone VARCHAR
  , p_serie VARCHAR
  , p_coo INTEGER
)
RETURNS void AS $$
DECLARE 
  id_dados_cliente INTEGER;
  id_cupom_fiscal INTEGER;
BEGIN
  id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom_fiscal IS NULL)
  THEN
   RAISE EXCEPTION 'Nenhum cupom fiscal encontrado referente ao dados do cliente.';
  END IF;

  id_dados_cliente = busca_dados_cliente(p_cpf_cnpj);
  IF (id_dados_cliente IS NULL)
  THEN
    INSERT INTO dados_cliente (
        nome
      , id_cupom
      , cpf_cnpj
      , logradouro
      , numero
      , bairro
      , codigo_municipio
      , nome_municipio
      , sigla_uf
      , cep
      , complemento
	  , telefone
    )
    VALUES (
          p_nome
        , id_cupom_fiscal
        , p_cpf_cnpj
        , p_logradouro
        , p_numero
        , p_bairro
        , p_codigo_municipio
        , p_nome_municipio
        , p_sigla_uf
        , p_cep
        , p_complemento
		, p_telefone
    );
  ELSE
  UPDATE dados_cliente
     SET nome = p_nome
       , id_cupom = id_cupom_fiscal
       , logradouro = p_logradouro
       , numero = p_numero
       , bairro = p_bairro
       , codigo_municipio = p_codigo_municipio
       , nome_municipio = p_nome_municipio
       , sigla_uf = p_sigla_uf
       , cep = p_cep
       , complemento = p_complemento
	   , telefone = p_telefone
   WHERE id = id_dados_cliente;
  END IF;
END;
$$  LANGUAGE plpgsql;

