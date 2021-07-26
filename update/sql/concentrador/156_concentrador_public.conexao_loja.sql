CREATE TABLE IF NOT EXISTS public.conexao_loja (
  id_loja INTEGER NOT NULL
, descricao_loja VARCHAR(100) NOT NULL
, servidor VARCHAR(15) NOT NULL
, porta INTEGER NOT NULL
, nome_banco VARCHAR(100) NOT NULL
, usuario VARCHAR (100) NOT NULL
, senha VARCHAR (100) NOT NULL
, CONSTRAINT pk_conexao_loja PRIMARY KEY (id_loja)
, CONSTRAINT unq_conexao_loja_descricao_loja UNIQUE (descricao_loja));
