INSERT INTO public.usuario 
	   (id, nome, nomereduzido, login, senha, modificado)
VALUES
	   (1, 'OPERADOR', 'OPERADOR', '1', md5('1'), false)
	 , (10, 'FISCAL', 'FISCAL', '10', md5('10'), false)
	 , (100, 'REDUCAO', 'REDUCAO', '100', md5('100'), false)
	 , (123, 'CPD', 'CPD', '123', md5('123'), false)
	 , (155, 'PROCESSA', 'PROCESSA', '155', md5('155'), false)
ON CONFLICT DO NOTHING;