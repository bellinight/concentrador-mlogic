--------------------------------------------------------------------------------
-- Verifica se já existe um Cupom Fiscal Eletrônico associado ao Cupom Fiscal --
--------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS public.busca_cupom_fiscal_eletronico;
CREATE OR REPLACE FUNCTION public.busca_cupom_fiscal_eletronico(p_cupom_fiscal INTEGER) 
RETURNS BOOLEAN AS $$

BEGIN
	return exists (select * 
			 from cupom_fiscal_eletronico 
			where cupom_fiscal = p_cupom_fiscal);
END;
$$  LANGUAGE plpgsql;

