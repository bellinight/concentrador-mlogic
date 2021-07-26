INSERT INTO public.papel 
	   (id, nome, modificado, percentual_desconto_maximo) 
VALUES
	   (1, 'OPERADOR', false, 99.00)
	 , (2, 'FISCAL', false, 99.00)
	 , (3, 'REDUCAO', false, 99.00)
ON CONFLICT (id) DO NOTHING;

SELECT setval('public.papel_id_seq'::regclass, (SELECT MAX(id) FROM public.papel));