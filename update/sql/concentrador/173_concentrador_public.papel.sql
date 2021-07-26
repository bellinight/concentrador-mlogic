UPDATE public.papel SET percentual_desconto_maximo = 99 WHERE percentual_desconto_maximo > 99;

ALTER TABLE IF EXISTS public.papel 
  ADD COLUMN IF NOT EXISTS percentual_desconto_maximo NUMERIC(18,2) NOT NULL DEFAULT 99.00
,DROP CONSTRAINT IF EXISTS chk_papel_desconto_maximo
, ADD CONSTRAINT chk_papel_desconto_maximo CHECK (percentual_desconto_maximo BETWEEN 0 AND 99);