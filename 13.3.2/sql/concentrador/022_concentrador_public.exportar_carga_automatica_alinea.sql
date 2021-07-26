DROP FUNCTION IF EXISTS public.exportar_carga_automatica_alinea();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_alinea()
RETURNS TABLE (
    id INTEGER
     , nome VARCHAR
     , bloqueio BOOLEAN
     , permiteprecodiferenciado BOOLEAN
     , desativado DATE
)
AS $$ 
BEGIN
  RETURN QUERY
  SELECT a.id
       , a.nome
       , a.bloqueio
       , a.permiteprecodiferenciado
       , a.desativado
    FROM alinea a
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;