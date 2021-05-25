/*
 * Esta função realiza a gravação dos dados do relatório saída operador.
 */ 
DROP FUNCTION IF EXISTS public.persiste_relatorio_saida_operador;
CREATE OR REPLACE FUNCTION public.persiste_relatorio_saida_operador(
		p_data_movimento 	DATE
	,	p_id_usuario 		INTEGER
	,	p_id_pdv 			INTEGER
	,	p_espelho 			TEXT
	) 
RETURNS void AS $$
	BEGIN
			INSERT INTO relatorio_saida_operador 
			(	data_movimento
			,   id_usuario
			,   id_pdv
			,   espelho
			)
			VALUES 
			(	p_data_movimento
			  , p_id_usuario
			  , p_id_pdv
			  , p_espelho);
END;
$$  LANGUAGE plpgsql;

