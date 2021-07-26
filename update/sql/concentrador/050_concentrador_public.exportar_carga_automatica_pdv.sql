DROP FUNCTION IF EXISTS public.exportar_carga_automatica_pdv();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_pdv()
RETURNS TABLE (
    id INTEGER
  , ip VARCHAR
  , atualizacao INTEGER
  , numerofabricacao VARCHAR
  , ultimocoo INTEGER
  , replicacao_desativado DATE
  , banco_dados VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT pdv.id
       , pdv.ip
       , pdv.atualizacao
       , ecf.numerofabricacao
       , pdv.ultimo_coo AS ultimocoo
       , pdv.replicacao_desativado
       , pdv.banco_dados
    FROM  pdv
   INNER JOIN ecf
      ON ecf.id = pdv.idecf
   WHERE pdv.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;