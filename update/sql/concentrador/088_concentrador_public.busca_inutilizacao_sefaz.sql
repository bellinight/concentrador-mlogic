DROP FUNCTION IF EXISTS public.busca_inutilizacao_sefaz;
CREATE OR REPLACE FUNCTION public.busca_inutilizacao_sefaz (
       p_serie INTEGER
     , p_ambiente INTEGER
     , p_numero_inicial INTEGER
     , p_numero_final INTEGER) 
RETURNS BOOLEAN AS $$

BEGIN
  RETURN EXISTS (
  SELECT * FROM inutilizacao_sefaz
   WHERE serie = p_serie
     AND ambiente = p_ambiente
     AND numero_inicial = p_numero_inicial
     AND numero_final = p_numero_final
  );
END;
$$  LANGUAGE plpgsql;