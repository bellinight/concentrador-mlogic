DROP FUNCTION IF EXISTS public.exportar_carga_automatica_aliquota();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_aliquota()
RETURNS TABLE (
    id VARCHAR
     , percentual DECIMAL(18,4)
     , tributado BOOLEAN
     , ordemenvio INTEGER
     , tipo INTEGER
     , desativado DATE
)
AS $$ 
BEGIN
  RETURN QUERY
  SELECT a.id
       , a.percentual
       , a.tributado
       , a.ordemenvio
       , a.tipo
       , a.desativado 
    FROM aliquota a
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;