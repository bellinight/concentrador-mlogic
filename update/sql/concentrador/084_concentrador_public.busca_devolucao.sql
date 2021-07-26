---------------------------------------------------------
-- Realiza a busca de devolucao no banco de dados. --
---------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_devolucao;
CREATE OR REPLACE FUNCTION public.busca_devolucao(p_id_documento_nao_fiscal INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_devolucao INTEGER;
BEGIN
  SELECT id
	 INTO  id_devolucao 
	 FROM  devolucao
	 WHERE id_documento_nao_fiscal = p_id_documento_nao_fiscal;
	RETURN id_devolucao;
END;
$$  LANGUAGE plpgsql;