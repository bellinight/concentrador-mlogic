/*
 * Esta função realiza a busca de um pagamento TEF considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_pagamento_tef;
CREATE OR REPLACE FUNCTION public.busca_pagamento_tef(
	p_id_sessao INTEGER,
	p_codigo INTEGER) 
RETURNS INTEGER AS $$

DECLARE id_pagamento_tef INTEGER;
BEGIN
 SELECT id
 INTO   id_pagamento_tef
 FROM   pagamentotef
 WHERE  idsessao = p_id_sessao
       AND codigo = p_codigo; 
 RETURN id_pagamento_tef;
END;
$$  LANGUAGE plpgsql;

