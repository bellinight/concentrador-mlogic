DO $$ 
<<inserir_modalidade_frete_padrao>>
BEGIN
  IF NOT (SELECT EXISTS (SELECT ID FROM public.modalidade_frete WHERE descricao ILIKE 'SEM FRETE')) THEN
     INSERT INTO public.modalidade_frete (descricao, codigo_modalidade, permite_desconto_frete, compoe_base_icms, compoe_base_pis_cofins, desativado, modificado) 
     VALUES ('SEM FRETE', 9, false, false, false, NULL, false);
  END IF;
END inserir_modalidade_frete_padrao $$;