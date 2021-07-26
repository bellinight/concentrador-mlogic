/*
 * Esta função realiza a gravação dos Clientes no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_cliente(p_dados JSON)
RETURNS BOOLEAN AS $$

BEGIN
-- Exclui a tabela temporária se existe
DROP TABLE IF EXISTS tbClienteTemp;
-- Tabela temporária
CREATE TEMPORARY TABLE tbClienteTemp (
    id INTEGER NOT NULL
     , idalinea INTEGER
     , nome VARCHAR NOT NULL
     , rua VARCHAR
     , numero INTEGER
     , bairro VARCHAR
     , complemento VARCHAR
     , cep VARCHAR
     , cidade VARCHAR
     , estado VARCHAR
     , cnpjcpf VARCHAR
     , cartao VARCHAR
     , limitecredito NUMERIC(18,4)
     , telefone VARCHAR
     , referencia VARCHAR
     , fisicojuridico CHAR
     , cod_ibge_municipio VARCHAR
     , inscricao_estadual VARCHAR
     , inscricao_municipal VARCHAR
     , suframa VARCHAR
     , idc_inscr_estadual CHAR(1)
     , utiliza_nfce BOOLEAN
);
-- Insere os dados na tabela temporária a partir de um json
INSERT INTO tbClienteTemp
SELECT * FROM json_populate_recordset(NULL::tbClienteTemp, p_dados);
-- Aplicando sanitização de dados
UPDATE tbClienteTemp
   SET telefone = substring(ltrim(rtrim(replace(telefone, ' ', ''))), 1, 15);
-- Quando algum cliente for inserido
INSERT INTO cliente
SELECT tb1.id
     , CASE WHEN alinea.id IS NULL THEN NULL ELSE tb1.idalinea END
     , SUBSTRING(tb1.nome, 1, 50)
     , SUBSTRING(tb1.rua, 1, 60)
     , CASE tb1.numero WHEN 0 THEN null ELSE tb1.numero END
     , null AS desativado
     , SUBSTRING(tb1.bairro, 1, 30)
     , SUBSTRING(tb1.complemento, 1, 20)
     , SUBSTRING(tb1.cep, 1, 10)
     , SUBSTRING(tb1.cidade, 1, 30)
     , SUBSTRING(tb1.estado, 1, 2)
     , SUBSTRING(tb1.cnpjcpf, 1, 14)
     , SUBSTRING(tb1.cartao, 1, 16)
     , tb1.limitecredito
     , tb1.telefone
     , SUBSTRING(tb1.referencia, 1, 50)
     , false AS modificado
     , SUBSTRING(tb1.fisicojuridico, 1, 1)
     , null AS email
     , SUBSTRING(tb1.inscricao_municipal, 1, 15)
     , SUBSTRING(tb1.inscricao_estadual, 1, 14)
     , tb1.idc_inscr_estadual
     , SUBSTRING(tb1.suframa, 1, 9)
     , SUBSTRING(tb1.cod_ibge_municipio, 1, 7)
     , null AS id_estrangeiro
     , tb1.utiliza_nfce
  FROM tbClienteTemp AS tb1 
  LEFT JOIN cliente AS cliente
    ON cliente.id = tb1.id
  LEFT JOIN alinea
    ON alinea.id = tb1.idalinea
 WHERE cliente.id IS NULL;
-- Quando algum cliente já existente for ativado
UPDATE cliente
   SET idalinea = CASE WHEN alinea.id IS NULL THEN NULL ELSE tb1.idalinea END
      , nome = SUBSTRING(tb1.nome, 1, 50)
      , rua = SUBSTRING(tb1.rua, 1, 60)
      , numero = CASE tb1.numero WHEN 0 THEN null ELSE tb1.numero END
      , bairro = SUBSTRING(tb1.bairro, 1, 30)
      , complemento = SUBSTRING(tb1.complemento, 1, 20)
      , cep = SUBSTRING(tb1.cep, 1, 10)
      , cidade = SUBSTRING(tb1.cidade, 1, 30)
      , estado = SUBSTRING(tb1.estado, 1, 2)
      , cnpjcpf = SUBSTRING(tb1.cnpjcpf, 1, 14)
      , cartao = SUBSTRING(tb1.cartao, 1, 16)
      , limitecredito = tb1.limitecredito
      , telefone = SUBSTRING(tb1.telefone, 1, 15)
      , referencia = SUBSTRING(tb1.referencia, 1, 50)
      , fisicojuridico = SUBSTRING(tb1.fisicojuridico, 1, 1)
      , cod_ibge_municipio = SUBSTRING(tb1.cod_ibge_municipio, 1, 7)
      , inscricao_estadual = SUBSTRING(tb1.inscricao_estadual, 1, 14)
      , inscricao_municipal = SUBSTRING(tb1.inscricao_municipal, 1, 15)
      , suframa = SUBSTRING(tb1.suframa, 1, 9)
      , idc_inscr_estadual = tb1.idc_inscr_estadual
      , modificado = true
      , desativado = null
      , utiliza_nfce = tb1.utiliza_nfce
   FROM tbClienteTemp tb1
   LEFT JOIN alinea ON alinea.id = tb1.idalinea
  WHERE cliente.id = tb1.id;
-- Quando algum cliente for excluído
UPDATE cliente SET desativado = CURRENT_DATE
  FROM (SELECT cliente.id
          FROM cliente
          LEFT JOIN tbClienteTemp AS tb1 ON tb1.id = cliente.id
         WHERE tb1.id IS NULL
           AND cliente.desativado IS NULL
        ) AS tb1
 WHERE tb1.id = cliente.id;
-- Exclui a tabela temporária
DROP TABLE tbClienteTemp;

RETURN TRUE;
END;
$$  LANGUAGE plpgsql;