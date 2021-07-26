INSERT INTO public.formapagamento (
       id
     , nome
     , ordemenvio
     , permitetroco
     , enviaimpressora
     , permitesangria
     , funcaoteclado
     , crediario
     , forma_pagamento_sefaz
     , modificado
     , limite_sangria)
VALUES (1, 'DINHEIRO', 1,true, false, true, true, false, '01', true, 500)
     , (2, 'CARTOES POS', 2, true, false, false, true, false, '99', true, 0)
     , (3, 'CARTAO CREDITO', 3, false, false, false, true, false, '03', true, 0)
     , (4, 'CARTAO DEBITO', 4, false, false, false, true, false, '04', true, 0)
     , (5, 'CHEQUE AVISTA', 5, true, false, true, true, false, '02', true, 0)
     , (6, 'CHEQUE PRAZO', 6, true, false, true, true, false, '02', true, 0)
     , (7, 'CONVENIOS', 7, false, false, false, true, false, '05', true, 0)
     , (8, 'TROCA FACIL', 8, true, false, false, true, false, '99', true, 0)
     , (9, 'CARTEIRA DIGITAL', 9, false, false, false, true, false, '99', true, 0)
    ON CONFLICT DO NOTHING;