DROP FUNCTION IF EXISTS public.exportar_carga_automatica_digital_usuario();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_digital_usuario()
RETURNS TABLE (
      id INTEGER
	, id_usuario INTEGER
	, polegar_direito     TEXT
	, polegar_esquerdo    TEXT
	, indicador_direito   TEXT
	, indicador_esquerdo  TEXT
	, medio_direito 	  TEXT
	, medio_esquerdo      TEXT
	, anelar_direito  	  TEXT
	, anelar_esquerdo 	  TEXT
	, minimo_direito 	  TEXT
	, minimo_esquerdo 	  TEXT 	
)
AS $$
BEGIN
  RETURN QUERY
  SELECT du.id
       , du.id_usuario
       , du.polegar_direito
	   , du.polegar_esquerdo
	   , du.indicador_direito
	   , du.indicador_esquerdo
	   , du.medio_direito
	   , du.medio_esquerdo
	   , du.anelar_direito
	   , du.anelar_esquerdo
	   , du.minimo_direito
	   , du.minimo_esquerdo
    FROM digital_usuario du
   WHERE du.desativado IS NULL
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;