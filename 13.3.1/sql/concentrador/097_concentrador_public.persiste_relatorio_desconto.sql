DROP FUNCTION IF EXISTS public.persiste_relatorio_desconto;
CREATE OR REPLACE FUNCTION public.persiste_relatorio_desconto (
       p_descricao VARCHAR
     , p_quantidade DECIMAL
     , p_desconto_unitario DECIMAL
     , p_desconto_total DECIMAL
     , p_serieecf VARCHAR
     , p_ccf INTEGER
     , p_codigo INTEGER
     , p_id_modalidade_promocional INTEGER
     , p_id_operador INTEGER
     , p_id_supervisor INTEGER
     , p_id_motivo_desconto INTEGER
	 , p_id_item INTEGER
	 , p_coo INTEGER
 ) 
RETURNS void AS $$

DECLARE id_cupom_fiscal INTEGER;

BEGIN
  id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serieecf, p_coo);
  
  IF (COALESCE(id_cupom_fiscal, 0) = 0) THEN
	RAISE EXCEPTION 'Cupom fiscal não escontrado com os parametros CCF[%], SERIEECF[%] E COO[%]', p_ccf, p_serieecf, p_coo;
  END IF;		
  
  INSERT INTO relatorio_desconto (
         descricao
       , quantidade
       , desconto_unitario
       , desconto_total
       , serieecf
       , ccf
       , codigo
       , id_modalidade_promocional
       , id_operador
       , id_supervisor
       , id_motivo_desconto
	   , id_item
	   , id_cupom_fiscal
  )
  VALUES (
         p_descricao
       , p_quantidade
       , p_desconto_unitario
       , p_desconto_total
       , p_serieecf
       , p_ccf
       , p_codigo
       , p_id_modalidade_promocional
       , p_id_operador
       , p_id_supervisor
       , p_id_motivo_desconto
	   , p_id_item
	   , id_cupom_fiscal
  );
END;
$$  LANGUAGE plpgsql;