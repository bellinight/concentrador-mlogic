/*
 * Esta função realiza a gravação dos Alineas no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_alinea(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
  -- Exclui a tabela temporária se existe
  DROP TABLE IF EXISTS tbAlineaTemp;
  
  -- Tabela temporária
  CREATE TEMPORARY TABLE tbAlineaTemp (
    id INTEGER NOT NULL,
    nome VARCHAR,
    bloqueio BOOLEAN NOT NULL,
    permiteprecodiferenciado BOOLEAN NOT NULL
  );
  
  -- Insere os dados na tabela temporária a partir de um json
  INSERT INTO tbAlineaTemp
  SELECT * FROM json_populate_recordset(NULL::tbAlineaTemp, p_dados);
  
  -- Quando algum alinea for inserido
  INSERT INTO alinea
  SELECT tb1.id
       , SUBSTRING(tb1.nome, 1, 40)
       , tb1.bloqueio
       , tb1.permiteprecodiferenciado
       , false AS modificado
       , null AS desativado
    FROM tbAlineaTemp AS tb1
    LEFT JOIN alinea AS alinea
           ON alinea.id = tb1.id
  WHERE alinea.id IS NULL;
  
  -- Quando algum alinea já existente for ativado
  UPDATE alinea
     SET nome = SUBSTRING(tb1.nome, 1, 40)
       , bloqueio = tb1.bloqueio
       , permiteprecodiferenciado = tb1.permiteprecodiferenciado
       , modificado = true
       , desativado = null
  FROM tbAlineaTemp tb1
  WHERE alinea.id = tb1.id;
  
  -- Quando algum alinea for excluído
  UPDATE alinea
     SET nome = SUBSTRING(tb1.nome, 1, 40)
       , bloqueio = tb1.bloqueio
       , permiteprecodiferenciado = tb1.permiteprecodiferenciado
       , modificado = true
       , desativado = null
  FROM tbAlineaTemp tb1
  WHERE alinea.id = tb1.id;
  
  -- Exclui a tabela temporária
  DROP TABLE tbAlineaTemp;
  
  RETURN TRUE;
END;
$$  LANGUAGE plpgsql;
