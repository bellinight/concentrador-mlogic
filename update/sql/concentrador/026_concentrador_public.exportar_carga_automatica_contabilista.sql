DROP FUNCTION IF EXISTS public.exportar_carga_automatica_contabilista();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_contabilista()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , cpf VARCHAR
  , crc VARCHAR
  , cnpj VARCHAR
  , cep VARCHAR
  , endereco VARCHAR
  , numeroimovel INTEGER
  , complemento VARCHAR
  , bairro VARCHAR
  , cidade VARCHAR
  , estado VARCHAR
  , fone VARCHAR
  , fax VARCHAR
  , email VARCHAR
  , codigomunicipioibge VARCHAR
)
AS $$
BEGIN
RETURN QUERY
SELECT c.id
     , c.nome
     , c.cpf
     , c.crc
     , c.cnpj
     , c.cep
     , c.endereco
     , c.numeroimovel
     , c.complemento
     , c.bairro
     , c.cidade
     , c.estado
     , c.fone
     , c.fax
     , c.email
     , c.codigomunicipioibge
  FROM contabilista c
 WHERE desativado IS NULL
 ORDER BY 1;
END;
$$  LANGUAGE plpgsql;