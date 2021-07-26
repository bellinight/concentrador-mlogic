INSERT INTO public.motivo_suprimento (id 
	 , descricao
	 , modificado
	 , desativado
) VALUES (99
		, 'INICIO DA SESSÃO DO OPERADOR'
		, TRUE
		, NULL
)
 ON CONFLICT DO NOTHING;
