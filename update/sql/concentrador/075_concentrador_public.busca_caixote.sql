------------------------------------------------------
-- Realiza a busca de um caixote no banco de dados. --
------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_caixote;
CREATE OR REPLACE FUNCTION public.busca_caixote(
   p_id_entrega INTEGER
  ,p_descricao  TEXT) 
RETURNS INTEGER AS $$

DECLARE id_caixote INTEGER;
BEGIN
  SELECT id
	 INTO  id_caixote 
	 FROM  caixote
	 WHERE id_entrega = p_id_entrega
		AND descricao = p_descricao;
	RETURN id_caixote;
END;
$$  LANGUAGE plpgsql;

