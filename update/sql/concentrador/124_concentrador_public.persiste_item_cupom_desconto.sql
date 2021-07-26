DROP FUNCTION IF EXISTS public.persiste_item_cupom_desconto;
CREATE OR REPLACE FUNCTION public.persiste_item_cupom_desconto (
       p_id_no_pdv BIGINT
     , p_id_item_cupom_fiscal_no_pdv BIGINT
     , p_ccf_no_pdv INTEGER
     , p_serie_no_pdv VARCHAR
     , p_coo_no_pdv INTEGER
     , p_id_modalidade INTEGER
     , p_quantidade_aplicada NUMERIC(18,4)
     , p_desconto_unitario NUMERIC(18, 8)
     , p_desconto_total NUMERIC(18, 4)
     , p_id_promocao_retaguarda BIGINT
     , p_nome_promocao_retaguarda VARCHAR(255)
     , p_quantidade_promocional NUMERIC(18,4)
     , p_pertence_scanntech BOOLEAN
     , p_id_motivo INTEGER
     , p_descricao_motivo VARCHAR(255)
     , p_id_supervisor INTEGER
     , p_nome_supervisor VARCHAR(255))
RETURNS void AS $$
DECLARE
  v_rec RECORD;
BEGIN
  SELECT icf.id as id_icf, icd.id as id_icd
    FROM public.itemcupomfiscal icf
    INTO v_rec
    JOIN public.cupomfiscal cf ON cf.id = icf.idcupomfiscal
    LEFT JOIN item_cupom_desconto icd ON icd.id_item_cupom_fiscal = icf.id
   WHERE icf.codigo = p_id_item_cupom_fiscal_no_pdv AND ccf = p_ccf_no_pdv 
     AND coo = p_coo_no_pdv AND cf.serieecf = p_serie_no_pdv;
 
  IF (v_rec IS NULL OR v_rec.id_icf IS NULL)
  THEN
    RAISE EXCEPTION 'Nenhum item de cupom encontrado referente ao item_cupom_desconto de ID: %', p_id_no_pdv;
  END IF;

  IF (v_rec.id_icf > 0)
  THEN
    IF (v_rec.id_icd IS NULL) THEN
        INSERT INTO public.item_cupom_desconto (
           id_no_pdv
         , id_item_cupom_fiscal
         , id_modalidade
         , quantidade_aplicada
         , desconto_unitario
         , desconto_total
         , id_promocao_retaguarda
         , nome_promocao_retaguarda
         , quantidade_promocional
         , pertence_scanntech
         , id_motivo
         , descricao_motivo
         , id_supervisor
         , nome_supervisor)
        VALUES (
           p_id_no_pdv
         , v_rec.id_icf
         , p_id_modalidade
         , p_quantidade_aplicada
         , p_desconto_unitario
         , p_desconto_total
         , p_id_promocao_retaguarda
         , p_nome_promocao_retaguarda
         , p_quantidade_promocional
         , p_pertence_scanntech
         , p_id_motivo 
         , p_descricao_motivo
         , p_id_supervisor
         , p_nome_supervisor);
    END IF;
 END IF;
END;
$$  LANGUAGE plpgsql;