DROP FUNCTION IF EXISTS public.exportar_carga_automatica_empresa();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_empresa()
RETURNS TABLE (
    id INTEGER
  , razaosocial VARCHAR
  , nomefantasia VARCHAR
  , cnpjceicpf VARCHAR
  , inscricaoestadual VARCHAR
  , inscricaomunicipal VARCHAR
  , digitoinscricaomunicipal VARCHAR
  , rua VARCHAR
  , numero INTEGER
  , bairro VARCHAR
  , complemento VARCHAR
  , cep VARCHAR
  , cidade VARCHAR
  , estado VARCHAR
  , telefone VARCHAR
  , email VARCHAR
  , fax VARCHAR
  , codigoibge INTEGER
  , suframa VARCHAR
  , nomecontato VARCHAR
  , codigo_sitef VARCHAR
  , cod_ibge_uf VARCHAR
  , regime_tributario VARCHAR
  , cnae VARCHAR
  , ie_substituto_trib VARCHAR
  , forma_lucro VARCHAR
  , pis DECIMAL(5,3)
  , cofins DECIMAL(5,3)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT emp.id
       , emp.razaosocial
       , emp.nomefantasia
       , emp.cnpjceicpf
       , emp.inscricaoestadual
       , emp.inscricaomunicipal
       , emp.digitoinscricaomunicipal
       , emp.rua
       , emp.numero
       , emp.bairro
       , emp.complemento
       , emp.cep
       , emp.cidade
       , emp.estado
       , emp.telefone
       , emp.email
       , emp.fax
       , emp.codigoibge
       , emp.suframa
       , emp.nomecontato
       , emp.codigo_sitef
       , emp.cod_ibge_uf
       , emp.regime_tributario
       , emp.cnae
       , emp.ie_substituto_trib
       , emp.forma_lucro
       , emp.pis
       , emp.cofins
    FROM empresa emp
   WHERE emp.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;