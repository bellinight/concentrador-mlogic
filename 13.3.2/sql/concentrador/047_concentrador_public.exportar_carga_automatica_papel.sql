DROP FUNCTION IF EXISTS public.exportar_carga_automatica_papel();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_papel()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , percentual_desconto_maximo NUMERIC(18,2)
)
AS $$
BEGIN
  RETURN QUERY
  SELECT p.id
       , p.nome
       , p.percentual_desconto_maximo
    FROM papel p
   WHERE p.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;