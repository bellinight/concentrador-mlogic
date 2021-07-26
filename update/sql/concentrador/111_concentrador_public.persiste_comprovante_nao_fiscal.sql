-- Function: persiste_comprovante_nao_fiscal(integer, integer, integer, numeric, integer, integer, timestamp without time zone, integer, boolean, integer, integer, timestamp without time zone, character varying)

-- DROP FUNCTION persiste_comprovante_nao_fiscal(integer, integer, integer, numeric, integer, integer, timestamp without time zone, integer, boolean, integer, integer, timestamp without time zone, character varying);
DROP FUNCTION IF EXISTS public.persiste_comprovante_nao_fiscal;
CREATE OR REPLACE FUNCTION public.persiste_comprovante_nao_fiscal(p_id_forma_pagamento integer, p_id_ecf integer, p_id_sessao integer, p_valor numeric, p_coo integer, p_gnf integer, p_data_hora_emissao timestamp without time zone, p_codigo integer, p_modificado boolean, p_numero_loja_sessao integer, p_id_pdv_sessao integer, p_abertura_sessao timestamp without time zone, p_denominacao character varying)
  RETURNS void AS
$BODY$

DECLARE id_comprovante_nao_fiscal INTEGER;
DECLARE id_sessao INTEGER;

BEGIN
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
 id_comprovante_nao_fiscal = busca_comprovante_nao_fiscal(p_id_ecf, id_sessao, p_codigo);  
                 
 IF (id_comprovante_nao_fiscal IS NULL) THEN
    
  INSERT INTO comprovantenaofiscal
   (idforma,
   idecf,
   idsessao,
   valor,
   coo,
   gnf,
   datahoraemissao,
   codigo,
   modificado,
   denominacao,
   md5_r06,
   md5_r07)
  VALUES (p_id_forma_pagamento, 
   p_id_ecf,
   id_sessao,
   p_valor,
   p_coo,
   p_gnf,
   p_data_hora_emissao,
   p_codigo,
   p_modificado,
   p_denominacao,
   md5('pi'),
   md5('pi'));
 END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  