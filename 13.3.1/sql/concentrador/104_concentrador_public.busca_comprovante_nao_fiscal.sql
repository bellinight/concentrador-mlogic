-- Function: busca_comprovante_nao_fiscal(integer, integer, integer)

-- DROP FUNCTION busca_comprovante_nao_fiscal(integer, integer, integer);
DROP FUNCTION IF EXISTS public.busca_comprovante_nao_fiscal;
CREATE OR REPLACE FUNCTION public.busca_comprovante_nao_fiscal(p_id_ecf integer, p_id_sessao integer, p_codigo integer)
  RETURNS integer AS
$BODY$

DECLARE id_comprovante_nao_fiscal INTEGER;
BEGIN
 SELECT id
 INTO   id_comprovante_nao_fiscal
 FROM   comprovantenaofiscal
 WHERE  idecf = p_id_ecf
        AND idsessao = p_id_sessao
        AND codigo = p_codigo;  
 RETURN id_comprovante_nao_fiscal;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
