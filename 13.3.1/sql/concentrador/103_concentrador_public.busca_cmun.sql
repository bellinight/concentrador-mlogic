CREATE OR REPLACE FUNCTION public.busca_cMun(p_municipio VARCHAR(255)) 
RETURNS INTEGER AS $$
DECLARE cMun INTEGER;
BEGIN
  cMun := 0;
  IF (p_municipio IS NOT NULL) THEN
    SELECT codigo_completo AS cMun
      INTO cMun
      FROM public.municipio
     WHERE unaccent(nome) ILIKE unaccent(p_municipio)
     LIMIT 1;
  END IF;
  IF (cMun is NULL OR cMun <= 0) THEN 
    SELECT codigoibge AS cMun
      INTO cMun
      FROM public.empresa
     LIMIT 1;
  END IF;
  RETURN cMun;
END;
$$ LANGUAGE plpgsql VOLATILE;