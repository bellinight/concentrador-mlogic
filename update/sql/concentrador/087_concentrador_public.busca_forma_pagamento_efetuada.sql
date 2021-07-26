/*
 * Esta função realiza a busca de um forma de pagamento efetuada considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_forma_pagamento_efetuada;
CREATE OR REPLACE FUNCTION public.busca_forma_pagamento_efetuada(
	p_id_cupom INTEGER,
	p_codigo INTEGER)
RETURNS INTEGER AS $$

DECLARE id_forma INTEGER;
BEGIN
 SELECT id
 INTO   id_forma
 FROM   formapagamentoefetuada
 WHERE  idcupom = p_id_cupom
        AND codigo = p_codigo;
 RETURN id_forma;
END;
$$  LANGUAGE plpgsql;

