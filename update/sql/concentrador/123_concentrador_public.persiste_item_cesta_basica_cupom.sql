/*
 * Esta função realiza a gravação dos dados do item cesta basica cupom.
 */ 
DROP FUNCTION IF EXISTS public.persiste_item_cesta_basica_cupom;
CREATE OR REPLACE FUNCTION public.persiste_item_cesta_basica_cupom(
	p_id_item_cupom_fiscal INTEGER,
	p_id_cesta_basica_cupom INTEGER,
	p_id_sessao INTEGER,
	p_codigo INTEGER,
	p_modificado BOOLEAN,
	p_codigo_item_cupom INTEGER,
	p_codigo_cesta_basica_cupom INTEGER,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
	p_ccf INTEGER,
	p_serie_ecf TEXT,
  p_coo INTEGER) 
RETURNS void AS $$

DECLARE id_item_cesta_basica INTEGER;
DECLARE id_sessao INTEGER;
DECLARE id_cesta_basica INTEGER;
DECLARE id_item_cupom INTEGER;
BEGIN
 id_cesta_basica = busca_cesta_basica_cupom(p_ccf, p_serie_ecf, p_codigo_cesta_basica_cupom, p_coo);
 id_item_cupom = busca_item_cupom_fiscal(p_id_item_cupom_fiscal, p_ccf, p_serie_ecf, p_coo);
 id_item_cesta_basica = busca_item_cesta_basica_cupom(id_item_cupom, id_cesta_basica, p_codigo);
 
 IF (id_item_cesta_basica IS NULL) THEN
    
  id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
  INSERT INTO itemcestabasicacupom
    (iditemcupomfiscal,
    idcestabasicacupom,
    idsessao,
    codigo,
    modificado,
    codigoitemcupom,
    codigocestabasicacupom)
  VALUES (id_item_cupom,
    id_cesta_basica,
    id_sessao,
    p_codigo,
    p_modificado,
    p_codigo_item_cupom,
    p_codigo_cesta_basica_cupom);
 END IF;
END;
$$  LANGUAGE plpgsql;

