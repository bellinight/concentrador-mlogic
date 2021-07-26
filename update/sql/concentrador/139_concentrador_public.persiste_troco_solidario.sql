-------------------------------------------------------------------------------------------------------
-- Esta função realiza a gravação do Troco Solidário no Concentrador. --
-------------------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_troco_solidario;
CREATE OR REPLACE FUNCTION public.persiste_troco_solidario(
	   p_id_cupom_fiscal INTEGER
	 , p_id_entidade INTEGER
	 , p_valor NUMERIC(18,2)
	 , p_data_doacao TIMESTAMP
	) 
 RETURNS void AS $$
DECLARE 
  id_troco_solidario INTEGER;
BEGIN
	id_troco_solidario = busca_troco_solidario(p_id_cupom_fiscal);
	IF (id_troco_solidario IS NULL)
		THEN
			INSERT INTO troco_solidario 
					(id_cupom
					,id_entidade
					,valor
					,data_doacao
					) 
			VALUES 	(p_id_cupom_fiscal
					,p_id_entidade
					,p_valor
					,p_data_doacao
					);
		ELSE
			UPDATE troco_solidario 
			SET id_cupom = p_id_cupom_fiscal
			  , id_entidade = p_id_entidade
			  , valor = p_valor
			  , data_doacao = p_data_doacao
			WHERE id = id_troco_solidario;
	END IF;
END;
$$  LANGUAGE plpgsql;