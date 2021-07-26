/*
 * Esta função realiza a gravação dos parâmetros de conexão com o Concentrador de cada loja.
 */
CREATE OR REPLACE FUNCTION public.carga_conexao_loja(p_dados JSON) 
RETURNS BOOLEAN AS $$
DECLARE v_existe BOOLEAN;
BEGIN
  SELECT EXISTS (     
         SELECT 1 FROM information_schema.tables 
         WHERE table_schema = 'public' 
         AND table_name = 'conexao_loja'
  ) INTO v_existe;
  
  IF NOT (v_existe) THEN
    RETURN TRUE;
  END IF;
  
  -- Exclui a tabela temporária se existe
  DROP TABLE IF EXISTS tbConexaoLoja;
  
  -- Tabela temporária
  CREATE TEMPORARY TABLE tbConexaoLoja (
    id_loja INTEGER NOT NULL,
	descricao_loja VARCHAR(100) NOT NULL,
	servidor VARCHAR(15) NOT NULL,
	porta INTEGER NOT NULL,
	nome_banco VARCHAR(100) NOT NULL, 
	usuario VARCHAR (100) NOT NULL,
	senha VARCHAR (100) NOT NULL
  );
  
  -- Insere os dados na tabela temporária a partir de um json
  INSERT INTO tbConexaoLoja
  SELECT * FROM json_populate_recordset(NULL::tbConexaoLoja, p_dados);

  
  DELETE FROM public.conexao_loja;
  INSERT INTO public.conexao_loja
  SELECT id_loja
       , descricao_loja
	   , servidor
	   , porta
	   , nome_banco
	   , usuario
	   , senha
	FROM tbConexaoLoja;

  -- Exclui a tabela temporária
  DROP TABLE IF EXISTS tbConexaoLoja;
  
  RETURN TRUE;
END;
$$  LANGUAGE plpgsql;
