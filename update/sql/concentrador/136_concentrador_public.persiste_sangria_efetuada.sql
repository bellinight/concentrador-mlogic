/*
 * Esta função realiza a gravação dos dados da sangria efetuada.
 */ 
DROP FUNCTION IF EXISTS public.persiste_sangria_efetuada;
CREATE OR REPLACE FUNCTION public.persiste_sangria_efetuada(
    p_id_forma integer, 
    p_id_sessao integer, 
    p_id_ecf integer, 
    p_codigo integer, 
    p_coo integer, 
    p_gnf integer, 
    p_data_hora_emissao timestamp without time zone, 
    p_valor numeric(18,4), 
    p_modificado boolean, 
    p_numero_loja_sessao integer, 
    p_id_pdv_sessao integer, 
    p_abertura_sessao timestamp without time zone, 
    p_denominacao VARCHAR(2),
	p_id_motivo_sangria INTEGER,
	p_numero_envelope VARCHAR(50),
	p_id_usuario_supervisor INTEGER)
  RETURNS void AS $BODY$

DECLARE id_sangria INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_sangria = busca_sangria_efetuada(p_id_ecf, p_coo, p_id_forma, p_gnf);
       
 IF (id_sangria IS NULL) THEN
    
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  INSERT INTO sangriaefetuada
    (idforma,
    idsessao,
    idecf,
    codigo,
    coo,
    gnf,
    datahoraemissao,
    valor,
    modificado,
	denominacao,
	md5_r06,
	id_motivo_sangria,
	numero_envelope,
	id_usuario_supervisor)
  VALUES (p_id_forma,
    id_sessao,
    p_id_ecf,
    p_codigo,
    p_coo,
    p_gnf,
    p_data_hora_emissao,
    p_valor,
    p_modificado,
	p_denominacao,
	md5('pi'),
	p_id_motivo_sangria,
	p_numero_envelope,
	p_id_usuario_supervisor);
 END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

