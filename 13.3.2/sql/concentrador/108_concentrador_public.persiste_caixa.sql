/*
 * Esta função realiza a gravação do caixa.
 */
DROP FUNCTION IF EXISTS public.persiste_caixa;
CREATE OR REPLACE FUNCTION public.persiste_caixa(
    p_codigo INTEGER,
	p_id_pdv INTEGER,
	p_nun_loja INTEGER,
	p_data TIMESTAMP,
	p_fechado BOOLEAN,
	p_data_movimento DATE,
	p_pecentual_mfd_livre TEXT,
	p_modificado BOOLEAN)
RETURNS void AS $$

DECLARE id_caixa INTEGER;
BEGIN
 id_caixa = busca_caixa(p_nun_loja, p_id_pdv, p_codigo, p_data);
 IF (id_caixa > 0) THEN
	UPDATE caixa
	SET    fechado = p_fechado, md5_e3 = md5('pi')
	WHERE  id = id_caixa;
 ELSE
	INSERT INTO caixa
	  (codigo,
	  idpdv,
	  numeroloja,
	  data,
	  fechado,
	  datamovimento,
	  percentualmfdlivre,
	  modificado,
	  md5_e3)
	VALUES (p_codigo,
	  p_id_pdv,
	  p_nun_loja,
	  p_data,
	  p_fechado,
	  p_data_movimento,
	  p_pecentual_mfd_livre,
	  p_modificado,
	  md5('pi'));
 END IF;
END;
$$  LANGUAGE plpgsql;

