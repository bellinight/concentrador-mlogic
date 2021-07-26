--depende de: public.papel, public.usuario
INSERT INTO public.papelusuario (idusuario, idpapel, modificado)
VALUES
	   (1, 1, false)
	 , (10, 2, false)
	 , (100, 3, false)
	 , (123, 3, false)
	 , (155, 2, false)
ON CONFLICT (idpapel, idusuario) DO NOTHING;

SELECT setval('public.papelusuario_id_seq'::regclass, (SELECT MAX(id) FROM public.papelusuario));