INSERT INTO public.motivo_desconto (
       id
     , descricao
     , modificado
     , desativado
)
VALUES (
       1
     , 'Preço Divergente'
     , false
     , null
)
 ON CONFLICT DO NOTHING;
