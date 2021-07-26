DO $$
<<refatoracao_item_cupom_desconto_v_13_3_2>>
BEGIN
  IF EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.columns WHERE TABLE_NAME LIKE 'item_cupom_desconto' AND COLUMN_NAME LIKE 'id_item_cupom_fiscal') THEN 
    RETURN;
  END IF;
   
  DROP TABLE IF EXISTS public.item_cupom_desconto;
  DROP SEQUENCE IF EXISTS public.item_cupom_desconto_id_seq;
  CREATE SEQUENCE IF NOT EXISTS public.item_cupom_desconto_id_seq;
  CREATE TABLE IF NOT EXISTS public.item_cupom_desconto (
         id BIGINT NOT NULL DEFAULT nextval('item_cupom_desconto_id_seq'::regclass)
       , id_no_pdv BIGINT NOT NULL
       , id_item_cupom_fiscal BIGINT NOT NULL
       , id_modalidade INTEGER NOT NULL
       , quantidade_aplicada NUMERIC(18,4) NOT NULL
       , desconto_unitario NUMERIC(18,8) NOT NULL
       , desconto_total NUMERIC(18,4) NOT NULL
       , id_promocao_retaguarda BIGINT 
       , nome_promocao_retaguarda VARCHAR(255) 
       , quantidade_promocional NUMERIC(18,4) NOT NULL
       , pertence_scanntech BOOLEAN NOT NULL DEFAULT FALSE
       , id_motivo INTEGER
       , descricao_motivo VARCHAR(255)
       , id_supervisor INTEGER
       , nome_supervisor VARCHAR(255)
       , CONSTRAINT pk_item_cupom_desconto PRIMARY KEY (id));
END refatoracao_item_cupom_desconto_v_13_3_2 $$

