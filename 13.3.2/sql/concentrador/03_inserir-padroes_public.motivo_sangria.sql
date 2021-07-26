INSERT INTO public.motivo_sangria (id
		  , descricao
		  , existe_envelope
		  , modificado
		  , desativado
) 
		VALUES (1
		  , 'Retirada'
		  , false
		  , true
		  , null
)
 ON CONFLICT DO NOTHING;