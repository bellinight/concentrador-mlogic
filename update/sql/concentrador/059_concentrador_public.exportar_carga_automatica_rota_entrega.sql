DROP FUNCTION IF EXISTS exportar_carga_automatica_rota_entrega();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_rota_entrega()
RETURNS TABLE (
    id INTEGER
  , descricao VARCHAR
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT re.id
       , re.descricao
       , re.desativado
    FROM rota_entrega re
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;