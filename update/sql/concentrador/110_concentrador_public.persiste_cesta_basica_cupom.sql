/*
 * Esta função realiza a gravação dos dados da cesta básica do cupom.
 */
DROP FUNCTION IF EXISTS public.persiste_cesta_basica_cupom;
CREATE OR REPLACE FUNCTION public.persiste_cesta_basica_cupom(
       p_id_cupom_fiscal INTEGER
     , p_id_item_cesta_basica INTEGER
     , p_id_sessao INTEGER
     , p_codigo INTEGER
     , p_modificado BOOLEAN
     , p_ccf INTEGER
     , p_serie_ecf TEXT
     , p_numero_loja_sessao INTEGER
     , p_id_pdv_sessao INTEGER
     , p_abertura_sessao TIMESTAMP
     , p_coo INTEGER
     , p_quantidade INTEGER)
RETURNS void AS $$

DECLARE id_cesta_basica INTEGER;
DECLARE id_cupom_fiscal INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
  id_cesta_basica = busca_cesta_basica_cupom(p_ccf, p_serie_ecf, p_codigo, p_coo);

  IF (id_cesta_basica IS NULL)
  THEN
    id_cupom_fiscal = busca_cupom_fiscal(p_ccf, p_serie_ecf, p_coo);
    id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);

    INSERT INTO cestabasicacupom (
           idcupomfiscal
         , iditemcestabasica
         , idsessao
         , codigo
         , modificado
         , quantidade)
    VALUES (
           id_cupom_fiscal
         , p_id_item_cesta_basica
         , id_sessao
         , p_codigo
         , p_modificado
         , p_quantidade);
 END IF;
END;
$$  LANGUAGE plpgsql;