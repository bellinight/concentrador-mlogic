/*
 * Esta função realiza a gravação da Transportadora no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_transportadora(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
	/*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
	DROP TABLE IF EXISTS tbTransportadoraTemp;
	/*TABELA TEMPORÁRIA*/
 	CREATE TEMPORARY TABLE tbTransportadoraTemp (
		id 						INTEGER NOT NULL,
		descricao 				VARCHAR NOT NULL,
		nome_fantasia 			VARCHAR,
		cpf_cnpj 				VARCHAR,
		inscricao_estadual 		VARCHAR,
		endereco 				VARCHAR,
		cep 					INTEGER NOT NULL,
		bairro 					VARCHAR NOT NULL,
		cidade 					VARCHAR NOT NULL,
		uf 						VARCHAR NOT NULL,
		telefone 				VARCHAR,
		autorizado_download_xml	INTEGER NOT NULL,
		rntrc 					INTEGER
	);
	/*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/		
	INSERT INTO tbTransportadoraTemp
		SELECT * FROM json_populate_recordset(NULL::tbTransportadoraTemp, p_dados);
	/*QUANDO ALGUMA TRANSPORTADORA FOR INSERIDA*/
	INSERT INTO transportadora
		SELECT tbl.id, tbl.descricao,tbl.nome_fantasia,
			tbl.cpf_cnpj,tbl.inscricao_estadual,tbl.endereco, 
			tbl.cep, tbl.bairro, tbl.cidade, tbl.uf, tbl.telefone,
			tbl.autorizado_download_xml, tbl.rntrc
	FROM tbTransportadoraTemp AS tbl
		LEFT JOIN transportadora AS transportadora ON transportadora.id = tbl.id 
	WHERE transportadora.id IS NULL;
	/*QUANDO ALGUMA TRANSPORTADORA FOR ALTERADA*/
	UPDATE transportadora 
	 SET descricao = tbl.descricao
		 ,nome_fantasia = tbl.nome_fantasia
		 ,cpf_cnpj = tbl.cpf_cnpj
		 ,inscricao_estadual = tbl.inscricao_estadual
		 ,endereco = tbl.endereco
		 ,cep = tbl.cep
		 ,bairro = tbl.bairro
		 ,cidade = tbl.cidade
		 ,uf = tbl.uf
		 ,telefone = tbl.telefone
		 ,autorizado_download_xml = tbl.autorizado_download_xml
		 ,rntrc = tbl.rntrc
	FROM tbTransportadoraTemp tbl
	WHERE transportadora.id = tbl.id;
	/*Excluir tabela temporária*/
	DROP TABLE tbTransportadoraTemp;
	
	RETURN TRUE;
END;
$$  LANGUAGE plpgsql;