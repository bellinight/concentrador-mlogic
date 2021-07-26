ALTER TABLE IF EXISTS public.cupom_fiscal_eletronico 
  ADD COLUMN IF NOT EXISTS ind_intermed INTEGER NOT NULL DEFAULT 0  /*SEM INTERMEDIADOR*/
, ADD COLUMN IF NOT EXISTS cnpj_intermed VARCHAR(18)
, ADD COLUMN IF NOT EXISTS identif_intermed_operacao VARCHAR(60);

COMMENT ON COLUMN public.cupom_fiscal_eletronico.ind_intermed IS '0 - SEM INTERMEDIADOR; 1 - COM INTERMEDIADOR';
COMMENT ON COLUMN public.cupom_fiscal_eletronico.cnpj_intermed IS 'CNPJ do intermediador, informado somente se ind_intermed = 1';
COMMENT ON COLUMN public.cupom_fiscal_eletronico.identif_intermed_operacao IS 'identificador (Razão Social, Nome Fantasia, etc) do intermediador da operação, informado somente se ind_intermed = 1';