/*
 * Para a execução desta function é necessário rodar a function "public.preparar_carga_automatica" 
 * para inclusão dos dados na tabela temporária.
 */
DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promocao_campanha();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promocao_campanha()
RETURNS TABLE (
    id INTEGER
  , id_promocao INTEGER
  , id_empresa_conveniada INTEGER
  , id_grupo_de_venda INTEGER
)
AS $$
BEGIN
  RETURN QUERY
  SELECT MIN(PC.id) AS id
       , tp.id AS id_promocao
       , pc.id_empresa_conveniada
       , pc.id_grupo_de_venda
    FROM promocao_campanha pc
    JOIN temppromocao tp
      ON tp.id_referencia = pc.id_campanha
     AND tp.id_modalidade = 2
   GROUP BY tp.id
          , pc.id_empresa_conveniada
          , pc.id_grupo_de_venda
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;
