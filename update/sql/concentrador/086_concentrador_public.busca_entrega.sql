-------------------------------------------------------
-- Realiza a busca de uma Entrega no banco de dados. --
-------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_entrega;
CREATE OR REPLACE FUNCTION public.busca_entrega(
   p_id_cupom_fiscal INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_entrega INTEGER;
BEGIN
  SELECT id
    INTO id_entrega 
    FROM entrega
   WHERE id_cupom_fiscal = p_id_cupom_fiscal;
  RETURN id_entrega;
END;
$$ LANGUAGE plpgsql;
