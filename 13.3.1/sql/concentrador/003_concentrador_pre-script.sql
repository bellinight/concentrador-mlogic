--ESTACIONAMENTO--
CREATE SCHEMA IF NOT EXISTS estacionamento
  AUTHORIZATION postgres;

GRANT ALL ON SCHEMA estacionamento TO postgres;
GRANT ALL ON SCHEMA estacionamento TO public;
COMMENT ON SCHEMA estacionamento
  IS 'Esquema do Controle de Estacionamento';
 
DROP TABLE IF EXISTS public.dadoscliente;
DROP FUNCTION IF EXISTS persiste_cupom_fiscal_eletronico (
p_ccf integer,
	p_serie_ecf character varying,
	p_serie character varying,
	p_numero character varying,
	p_cd_tipo_emissao character varying,
	p_tipo_impressao character varying,
	p_ambiente character varying,
	p_consumidor_final character varying,
	p_presencial character varying,
	p_versao_aplicativo character varying,
	p_cgc_autorizados character varying,
	p_tipo_finalidade character varying,
	p_observacao character varying,
	p_situacao character varying,
	p_dh_autorizacao timestamp without time zone,
	p_msg_retornada character varying,
	p_dh_contingencia timestamp without time zone,
	p_justificativa character varying,
	p_chave_eletronica character varying,
	p_xml_gerado text,
	p_versao_xml character varying,
	p_total_tributos numeric,
	p_protocolo_autorizacao character varying,
	p_total_icms numeric,
	p_digest_value character varying,
	p_danfe_emitido boolean,
	p_dh_emissao timestamp without time zone,
	p_url_qrcode text,
	p_coo integer,
	p_tributo_federal numeric,
	p_tributo_estadual numeric,
	p_tributo_municipal numeric);

DROP FUNCTION IF EXISTS public.exportar_carga_automatica_configuracao_paf_ecf();

DO $$ 
<<deletando_papeloperacao_duplicado>>
DECLARE
v_rec RECORD;
BEGIN
  FOR v_rec IN    
     SELECT pu.idoperacao, pu.idpapel, MIN(pu.id) as id
     FROM public.papeloperacao pu
     GROUP BY pu.idoperacao, pu.idpapel
     HAVING COUNT(pu.id)> 1
  LOOP
    DELETE FROM public.papeloperacao 
     WHERE idoperacao = v_rec.idoperacao 
       AND idpapel = v_rec.idpapel AND id <> v_rec.id;
    RAISE NOTICE 'REMOVIDO DUPLICADO: OPERACAO:% PAPEL:%', v_rec.idoperacao, v_rec.idpapel;
  END LOOP;
END deletando_papeloperacao_duplicado $$;

DO $$ 
<<deletando_papelusuario_duplicado>>
DECLARE
v_dup RECORD;
BEGIN
  FOR v_dup IN
     SELECT pu.idusuario, pu.idpapel, MIN(pu.id) AS id
     FROM public.papelusuario pu
     GROUP BY pu.idusuario, pu.idpapel
     HAVING COUNT(pu.id)> 1
  LOOP
    DELETE FROM public.papelusuario 
     WHERE idusuario = v_dup.idusuario 
       AND idpapel = v_dup.idpapel AND id <> v_dup.id;
    RAISE NOTICE 'REMOVIDO DUPLCIADO: USUARIO:% PAPEL:%', v_dup.idusuario, v_dup.idpapel;
  END LOOP;
END deletando_papelusuario_duplicado $$;

ALTER TABLE public.papelusuario 
       DROP CONSTRAINT IF EXISTS unq_papelusuario_idpapel_idusuario
      , ADD CONSTRAINT unq_papelusuario_idpapel_idusuario UNIQUE (idpapel, idusuario);

ALTER TABLE public.papeloperacao 
       DROP CONSTRAINT IF EXISTS unq_papeloperacao_idpapel_idoperacao
      , ADD CONSTRAINT unq_papeloperacao_idpapel_idoperacao UNIQUE (idpapel, idoperacao);