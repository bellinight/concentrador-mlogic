ALTER TABLE IF EXISTS public.entrega
ALTER COLUMN telefone TYPE VARCHAR(20);

ALTER TABLE IF EXISTS public.entrega
ALTER COLUMN bairro TYPE VARCHAR(60);

ALTER TABLE IF EXISTS public.entrega
ALTER COLUMN cidade TYPE VARCHAR(60);

ALTER TABLE IF EXISTS public.entrega
 DROP CONSTRAINT IF EXISTS fka12275b8488cf43f;
 
ALTER TABLE IF EXISTS public.entrega
 DROP CONSTRAINT IF EXISTS fk_dm68xbp79u187qgjktpuw8uxs /*FK ID_TRANSPORTADORA*/; 

ALTER TABLE IF EXISTS public.entrega
ALTER COLUMN id_rota_entrega DROP NOT NULL;
