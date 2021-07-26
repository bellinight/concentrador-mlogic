DROP FUNCTION IF EXISTS exportar_carga_automatica_transportadora();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_transportadora()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , nome_fantasia VARCHAR
  , cpf_cnpj VARCHAR
  , inscricao_estadual VARCHAR
  , endereco VARCHAR
  , cep INTEGER
  , bairro VARCHAR
  , cidade VARCHAR
  , uf VARCHAR
  , telefone VARCHAR
  , autorizado_download_xml INTEGER
  , rntrc INTEGER
)AS $$
DECLARE 
  v_utilizar_dados_empresa BOOLEAN;
BEGIN
  SELECT valor
    INTO v_utilizar_dados_empresa
    FROM configuracao
   WHERE chave = 'entrega.utilizar-empresa-como-transportadora'
     AND desativado IS NULL;
IF (v_utilizar_dados_empresa) 
THEN
  RETURN QUERY
  SELECT emp.id
       , emp.razaosocial AS descricao
       , emp.nomefantasia AS nome_fantasia
       , emp.cnpjceicpf AS cpf_cnpj
       , emp.inscricaoestadual AS inscricao_estadual
       , emp.rua AS endereco
       , emp.cep::INTEGER
       , emp.bairro
       , emp.cidade
       , emp.estado AS uf
       , emp.telefone
       , emp.id AS autorizado_download_xml
       , emp.id AS rntrc
    FROM empresa emp
   ORDER BY 1;
ELSE
  RETURN QUERY
  SELECT transp.id
       , transp.descricao
       , transp.nome_fantasia
       , transp.cpf_cnpj
       , transp.inscricao_estadual
       , transp.endereco
       , transp.cep
       , transp.bairro
       , transp.cidade
       , transp.uf
       , transp.telefone
       , transp.autorizado_download_xml
       , transp.rntrc
    FROM transportadora transp
   ORDER BY 1;
END IF;
END;
$$  LANGUAGE plpgsql;