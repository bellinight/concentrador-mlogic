DO $$ <<implementacao_tabela_modalidade_promocional_v_13_3_2>>
BEGIN
  CREATE TABLE IF NOT EXISTS public.modalidade_promocional(
         id INTEGER NOT NULL PRIMARY KEY
       , descricao VARCHAR(50) NOT NULL
       , prioridade INTEGER NOT NULL);
  
  IF EXISTS ( SELECT 1 FROM public.modalidade_promocional LIMIT 1 ) THEN 
     RETURN;
  END IF;
  
  INSERT INTO public.modalidade_promocional 
  VALUES (1,'PACK VIRTUAL', 1)
       , (2,'CAMPANHA', 2)
       , (3,'A PARTIR DE', 3)
       , (4,'PRECO PROMOCIONAL', 4)
       , (5,'DESCONTO APLICADO', 5)
       , (6,'DESCONTO FINAL DO CUPOM', 6)
       , (7,'DESCONTO PRE VENDA', 7);
END implementacao_tabela_modalidade_promocional_v_13_3_2 $$