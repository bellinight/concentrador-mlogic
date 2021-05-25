DROP FUNCTION IF EXISTS public.exportar_carga_automatica_estacionamento_abono();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_estacionamento_abono()
RETURNS TABLE (
    id INTEGER
  , valor DECIMAL(18,4)
  , tempo INTEGER
  , desativado DATE
)
AS $$
BEGIN
  RETURN QUERY
  SELECT est.id
       , est.valor
       , est.tempo
       , est.desativado 
    FROM estacionamento.abono est
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;