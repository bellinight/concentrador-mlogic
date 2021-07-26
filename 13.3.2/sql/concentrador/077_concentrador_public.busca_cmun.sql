DROP FUNCTION IF EXISTS public.busca_cMun;
CREATE or REPLACE FUNCTION public.busca_cMun(
   p_municipio VARCHAR(255)
 , p_sigla_uf VARCHAR(2)) 
RETURNS INTEGER AS $$
DECLARE cMun INTEGER;
BEGIN
  cMun := 0;
  IF (p_municipio IS NOT NULL) THEN
    SELECT codigo_completo AS cMun
      INTO cMun
      FROM public.municipio
     WHERE unaccent(nome) ILIKE unaccent(p_municipio) AND sigla_uf  ILIKE p_sigla_uf
     LIMIT 1;
  END IF;
  IF (cMun IS NULL OR cMun <= 0) THEN 
    SELECT codigoibge AS cMun
      INTO cMun
      FROM public.empresa
     LIMIT 1;
  END IF;
  RETURN cMun;
END;
$$ LANGUAGE plpgsql VOLATILE;