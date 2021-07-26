DROP FUNCTION IF EXISTS public.exportar_carga_automatica_cliente();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_cliente()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , rua VARCHAR
  , numero INTEGER
  , bairro VARCHAR
  , complemento VARCHAR
  , cep VARCHAR
  , cidade VARCHAR
  , estado VARCHAR
  , cnpjcpf VARCHAR
  , cartao VARCHAR
  , limitecredito DECIMAL(18,4)
  , telefone VARCHAR
  , referentecia VARCHAR
  , idalinea INTEGER
  , desativado DATE
  , email VARCHAR
  , inscricao_municipal VARCHAR
  , inscricao_estadual VARCHAR
  , idc_inscr_estadual VARCHAR
  , suframa VARCHAR
  , cod_ibge_municipio VARCHAR
  , id_estrangeiro VARCHAR
  , utiliza_nfce BOOLEAN
)
AS $$
BEGIN
  RETURN QUERY
  SELECT c.id
       , c.nome
       , c.rua
       , c.numero
       , c.bairro
       , c.complemento
       , c.cep
       , c.cidade
       , c.estado
       , c.cnpjcpf
       , c.cartao
       , c.limitecredito
       , c.telefone
       , c.referencia
       , c.idalinea
       , c.desativado
       , c.email
       , c.inscricao_municipal
       , c.inscricao_estadual
       , c.idc_inscr_estadual
       , c.suframa
       , c.cod_ibge_municipio
       , c.id_estrangeiro
       , c.utiliza_nfce
    FROM cliente c
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;