DROP FUNCTION IF EXISTS public.gerar_xml_nfce(p_idcupomfiscal integer);

CREATE OR REPLACE FUNCTION public.gerar_xml_nfce(p_idcupomfiscal integer) RETURNS xml AS
$BODY$

DECLARE
  tag_xml  XML;
  v_empresa  RECORD;

BEGIN

  SELECT id AS id
       , BTRIM(estado) AS estado
    INTO v_empresa
    FROM empresa
   LIMIT 1;

  IF (v_empresa.estado = 'MG')
  THEN
    tag_xml := function_nfce_mg(p_idcupomfiscal, v_empresa.id);
  ELSE
    tag_xml := function_nfce_rj(p_idcupomfiscal, v_empresa.id);
  END IF;

  RETURN tag_xml;

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

