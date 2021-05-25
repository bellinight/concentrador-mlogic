CREATE TABLE IF NOT EXISTS public.pre_venda (
       id SERIAL NOT NULL PRIMARY KEY
     , id_cupom_fiscal INTEGER NOT NULL
     , id_cliente INTEGER
     , cod_pedido_venda INTEGER NOT NULL
     , data_venda TIMESTAMP
     , cod_pdv INTEGER
     , status VARCHAR(10)
     , consumidor_final BOOLEAN
     , propagado BOOLEAN
     , CONSTRAINT fk_cupom_fiscal FOREIGN KEY (id_cupom_fiscal) REFERENCES public.cupomfiscal (id)
     , CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES public.cliente (id)
);