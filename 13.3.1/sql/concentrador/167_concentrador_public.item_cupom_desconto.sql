CREATE TABLE IF NOT EXISTS public.item_cupom_desconto (
       id SERIAL NOT NULL PRIMARY KEY
     , codigo INTEGER
     , serie VARCHAR(50)
     , id_cupom INTEGER
     , indice_item INTEGER
     , valor_desconto NUMERIC(18, 4)
     , id_modalidade INTEGER NOT NULL
     , quantidade_aplicada NUMERIC(18,4) DEFAULT 0 NOT NULL
);
