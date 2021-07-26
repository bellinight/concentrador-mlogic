/*
 * Esta função realiza a busca de sangria considerando os parâmetros passados.
 */
DROP FUNCTION IF EXISTS public.busca_sangria_efetuada;
CREATE OR REPLACE FUNCTION public.busca_sangria_efetuada(
    p_id_ecf integer, 
    p_coo integer, 
    p_id_forma integer,
    p_gnf integer)
    
  RETURNS integer AS $BODY$

DECLARE id_sangria INTEGER;
BEGIN
 SELECT id
 INTO   id_sangria
 FROM   sangriaefetuada
 WHERE idecf = p_id_ecf
   AND coo = p_coo
   AND idforma = p_id_forma
   AND gnf = p_gnf;
 RETURN id_sangria;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

