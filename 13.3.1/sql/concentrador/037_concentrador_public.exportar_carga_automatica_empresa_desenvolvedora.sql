DROP FUNCTION IF EXISTS public.exportar_carga_automatica_empresa_desenvolvedora();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_empresa_desenvolvedora()
RETURNS TABLE (
    id INTEGER
  , razaosocial VARCHAR
  , nomefantasia VARCHAR
  , cnpj VARCHAR
  , rua VARCHAR
  , numero INTEGER
  , bairro VARCHAR
  , complemento VARCHAR
  , cep INTEGER
  , cidade VARCHAR
  , estado VARCHAR
  , telefone VARCHAR
  , email VARCHAR
  , fax VARCHAR
  , nomesoftware VARCHAR
  , versao VARCHAR
  , nomecontato VARCHAR
  , inscricaoestadual VARCHAR
  , inscricaomunicipal VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT emp_desenv.id
       , emp_desenv.razaosocial
       , emp_desenv.nomefantasia
       , emp_desenv.cnpj
       , emp_desenv.rua
       , emp_desenv.numero
       , emp_desenv.bairro
       , emp_desenv.complemento
       , emp_desenv.cep
       , emp_desenv.cidade
       , emp_desenv.estado
       , emp_desenv.telefone
       , emp_desenv.email
       , emp_desenv.fax
       , emp_desenv.nomesoftware
       , emp_desenv.versao
       , emp_desenv.nomecontato
       , emp_desenv.inscricaoestadual
       , emp_desenv.inscricaomunicipal
    FROM empresadesenvolvedora emp_desenv
   WHERE emp_desenv.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;