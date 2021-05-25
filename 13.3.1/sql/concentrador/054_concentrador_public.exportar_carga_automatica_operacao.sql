DROP FUNCTION IF EXISTS public.exportar_carga_automatica_operacao();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_operacao()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , imprimir BOOLEAN
  , nome_reduzido VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT op.id
       , op.nome
       , op.imprimir
       , op.nome_reduzido
    FROM operacao op
   WHERE op.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;