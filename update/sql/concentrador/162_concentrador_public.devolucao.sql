 ALTER TABLE IF EXISTS public.devolucao
 ALTER COLUMN serie TYPE INTEGER USING serie::INTEGER;