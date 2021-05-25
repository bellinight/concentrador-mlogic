ALTER TABLE public.correspondentebancario
 DROP CONSTRAINT IF EXISTS unique_correspondentebancario;

ALTER TABLE public.correspondentebancario
  ADD CONSTRAINT unique_correspondentebancario UNIQUE(idsessao, valorpago, codigo);