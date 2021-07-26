DROP FUNCTION IF EXISTS public.obter_ultimo_ccf;
CREATE OR REPLACE FUNCTION public.obter_ultimo_ccf(
        p_serie INTEGER
      , p_ambiente VARCHAR) 
RETURNS INTEGER AS $$

DECLARE ccf INTEGER;

BEGIN
 SELECT MAX(numero) 
   INTO ccf
   FROM cupom_fiscal_eletronico
  WHERE serie = p_serie
	  AND ambiente = p_ambiente;
 RETURN ccf;
END;
$$  LANGUAGE plpgsql;