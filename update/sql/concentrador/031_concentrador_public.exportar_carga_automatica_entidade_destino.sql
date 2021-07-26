DROP FUNCTION IF EXISTS public.exportar_carga_automatica_entidade_destino();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_entidade_destino()
RETURNS TABLE (
    id INTEGER
  , codigo VARCHAR(60)
  , razao_social VARCHAR(60)
  , nome_fantasia VARCHAR(50)
  , cnpj VARCHAR(50)
  , inscricao_estadual VARCHAR(50)
  , inscricao_municipal VARCHAR(50)
  , plano_pagamento VARCHAR(50)
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT ed.id
       , ed.codigo
	   , ed.razao_social
	   , ed.nome_fantasia
	   , ed.cnpj
	   , ed.inscricao_estadual
	   , ed.inscricao_municipal
	   , ed.plano_pagamento
	   , ed.desativado
    FROM entidade_destino ed
   WHERE ed.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;