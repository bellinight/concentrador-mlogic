---------------------------------------------------------
-- Realiza a busca de dados_cliente no banco de dados. --
---------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_dados_cliente;
CREATE OR REPLACE FUNCTION public.busca_dados_cliente(p_cpf_cnpj TEXT) 
RETURNS INTEGER AS $$

DECLARE id_dados_cliente INTEGER;
BEGIN
  SELECT id
	 INTO  id_dados_cliente 
	 FROM  dados_cliente
	 WHERE cpf_cnpj = p_cpf_cnpj;
	RETURN id_dados_cliente;
END;
$$  LANGUAGE plpgsql;

