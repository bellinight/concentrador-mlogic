------------------------------------------------------------------------------
--	Esta função serve como um facilitador para identificar todos os 		--
--	Itens de Domínio da Informações pertencentes ao Dominio da Informação	--
--  que se deseja consultar.												--
------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.consultarDominio;
CREATE OR REPLACE FUNCTION public.consultarDominio(pNomeDominio TEXT) RETURNS TEXT AS $$

DECLARE  
	v_item		RECORD;
	v_retorno	TEXT;
	v_count		INTEGER;

BEGIN   
 
	v_count   := 0;
	
	FOR v_item IN	SELECT d.descricao as descricao_dominio
			      ,i.indicador as indicador_item
			      ,i.descricao as descricao_item
			  FROM dominio_informacao d
			      ,item_dominio_informacao i
			  WHERE  d.nome = pNomeDominio
			    AND d.id = i.dominio

	LOOP
		v_count := v_count + 1;
		
		IF (v_count = 1) 
		THEN
			v_retorno := v_item.descricao_dominio || '[' || pNomeDominio  || ']' || E'\n';	
			v_retorno := v_retorno || E'------------------------------\n';	
		END IF;
		
		v_retorno := v_retorno || ' [' || v_item.indicador_item || '] ' || v_item.descricao_item || E'\n';
	END LOOP;

	return v_retorno;
      
END;
$$ LANGUAGE plpgsql;

