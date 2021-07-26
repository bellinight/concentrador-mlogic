--depende de: public.pre_venda
CREATE TABLE IF NOT EXISTS public.item_pre_venda (id SERIAL NOT NULL PRIMARY KEY
     , id_pre_venda INTEGER NOT NULL
     , id_item INTEGER NOT NULL
     , preco DECIMAL(18,4)
     , quantidade DECIMAL(18,4)
     , valor_total DECIMAL(18,4)
     , valor_desconto DECIMAL(18,4)
     , valor_liquido DECIMAL(18,4)
     , CONSTRAINT fk_pre_venda FOREIGN KEY (id_pre_venda) REFERENCES public.pre_venda (id)
     , CONSTRAINT fk_item FOREIGN KEY (id_item) REFERENCES public.item (id)
);