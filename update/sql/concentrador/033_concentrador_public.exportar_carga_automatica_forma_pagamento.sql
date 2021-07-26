DROP FUNCTION IF EXISTS public.exportar_carga_automatica_forma_pagamento();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_forma_pagamento()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , permitetroco BOOLEAN
  , enviaimpressora BOOLEAN
  , permitesangria BOOLEAN
  , funcaoteclado BOOLEAN
  , ordemenvio INTEGER
  , desativado DATE
  , forma_pagamento_sefaz VARCHAR
  , cartao_pos BOOLEAN
  , limite_sangria DECIMAL(18,4)
  , exibir_pdv BOOLEAN
  , id_forma_pai INTEGER
  , crediario BOOLEAN
  , convenio BOOLEAN
  , incluir_cliente_crediario BOOLEAN
  , limite_valor_cheque DECIMAL(18,4)
  , limite_troco_cheque DECIMAL(18,4)
  , validar_cliente BOOLEAN
  , solicitar_fiscal BOOLEAN
)
AS $$ 
BEGIN
  RETURN QUERY
  SELECT fp.id
       , fp.nome
       , fp.permitetroco
       , fp.enviaimpressora
       , fp.permitesangria
       , fp.funcaoteclado
       , fp.ordemenvio
       , fp.desativado
       , fp.forma_pagamento_sefaz
       , fp.cartao_pos
       , fp.limite_sangria
       , fp.exibir_pdv
       , fp.id_forma_pai
       , fp.crediario
       , fp.convenio
       , fp.incluir_cliente_crediario
       , fp.limite_valor_cheque
       , fp.limite_troco_cheque
       , fp.validar_cliente
	   , fp.solicitar_fiscal
    FROM formapagamento fp
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;