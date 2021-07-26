/*
 * Para a execução desta function é necessário rodar a function "public.preparar_carga_automatica" 
 * para inclusão dos dados na tabela temporária.
 */
DROP FUNCTION IF EXISTS public.exportar_carga_automatica_promocao_pack_virtual();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_promocao_pack_virtual()
RETURNS TABLE (
        id_promocao INTEGER
      , id_tipo_pack INTEGER
      , id_agrupamento INTEGER
      , id_item INTEGER
      , leve NUMERIC(18,4)
      , ganhe NUMERIC(18,4)
      , tipo_aplicacao SMALLINT
      , nivel_aplicacao VARCHAR(1)
      , valor_aplicacao NUMERIC(18,4)
      , limite_aplicacao INTEGER
      , pertence_scanntech BOOLEAN
)AS $$
BEGIN
  RETURN QUERY
  SELECT tp.id AS id_promocao
       , ppv.id_tipo_pack_virtual AS id_tipo_pack
       , ppv.cod_agrupamento AS id_agrupamento
       , ppv.id_item
       , ppv.leve
       , ppv.ganhe
       , ppv.tipo_aplicacao
       , ppv.nivel_aplicacao
       , ppv.valor AS valor_aplicacao
       , ppv.limite_promocao_por_cupom AS limite_aplicacao
       , ppv.pertence_scanntech
    FROM promocao_pack_virtual ppv
    JOIN tempPromocao tp
      ON tp.id_retaguarda = ppv.id_pack_virtual
   WHERE tp.id_modalidade = 1
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;
