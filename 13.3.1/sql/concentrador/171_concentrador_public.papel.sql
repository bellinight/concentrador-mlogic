ALTER TABLE public.papel DROP CONSTRAINT IF EXISTS chk_papel_desconto_maximo;
ALTER TABLE public.papel ADD CONSTRAINT chk_papel_desconto_maximo CHECK (percentual_desconto_maximo BETWEEN 0 AND 99);