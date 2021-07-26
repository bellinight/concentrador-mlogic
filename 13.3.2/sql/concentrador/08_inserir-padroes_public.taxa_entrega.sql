DO $$ 
<<inserir_taxa_entrega_padrao>>
BEGIN
  PERFORM setval('taxa_entrega_id_seq', (SELECT MAX(id) FROM public.taxa_entrega));
  IF NOT (SELECT EXISTS (SELECT ID FROM public.taxa_entrega WHERE descricao ILIKE 'GRÁTIS')) THEN
     INSERT INTO public.taxa_entrega (descricao, valor, desativado, modificado) 
     VALUES ('GRÁTIS', 0.00, NULL, false);
  END IF;
END inserir_taxa_entrega_padrao $$;