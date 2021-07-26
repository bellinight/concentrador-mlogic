/*
 * Esta função realiza a busca de um Troco Solidário.
 */
DROP FUNCTION IF EXISTS public.busca_troco_solidario;
CREATE OR REPLACE FUNCTION public.busca_troco_solidario(
	   p_id_cupom_fiscal INTEGER
)
RETURNS INTEGER AS $$

DECLARE id_troco_solidario INTEGER;
BEGIN
 SELECT id
 INTO   id_troco_solidario
 FROM   troco_solidario
 WHERE  id_cupom = p_id_cupom_fiscal;
 RETURN id_troco_solidario;
END;
$$  LANGUAGE plpgsql;
