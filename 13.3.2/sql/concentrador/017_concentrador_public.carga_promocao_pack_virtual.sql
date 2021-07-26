/*
 * Esta função realiza a gravação da Promoção Campanha Pack Virtual no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_promocao_pack_virtual(p_dados JSON)
RETURNS BOOLEAN AS $$

BEGIN
  --Exclui a tabela temporária se existe
  DROP TABLE IF EXISTS tbPromocaoPackVirtualTemp;
  
  --Tabela temporária
  CREATE TEMPORARY TABLE tbPromocaoPackVirtualTemp (
      id_pack_virtual INTEGER NOT NULL
    , descricao VARCHAR (100) NOT NULL
    , data_inicial TIMESTAMP NOT NULL
    , data_final TIMESTAMP NOT NULL
    , data_criacao TIMESTAMP NOT NULL
    , id_tipo_pack_virtual INTEGER NOT NULL
    , tipo_pack_virtual VARCHAR (100) NOT NULL
    , limite_promocao_por_cupom INTEGER
    , nivel_aplicacao VARCHAR (1) NOT NULL
    , indicador SMALLINT NOT NULL
    , id_item INTEGER NOT NULL
    , cod_agrupamento INTEGER NOT NULL
    , leve NUMERIC(18,4) NOT NULL
    , ganhe NUMERIC(18,4) NOT NULL
    , valor NUMERIC(18,4) NOT NULL
    , pertence_scanntech BOOLEAN NOT NULL
    , tipo_aplicacao SMALLINT NOT NULL
    , valor_aplicacao_pack NUMERIC(18,4) NOT NULL
  );
  
  --Insere os dados na tabela temporária a partir de um json
  INSERT INTO tbPromocaoPackVirtualTemp
  SELECT * FROM json_populate_recordset(NULL::tbPromocaoPackVirtualTemp, p_dados);
  
  --Antes de importar alguma promoção pack virtual apagar a tabela, pois não importa as informações históricas
  DELETE FROM promocao_pack_virtual;
  
  --Quando alguma promoção pack virtual for inserida
  INSERT INTO promocao_pack_virtual (
      id_pack_virtual
    , descricao
    , data_inicial
    , data_final
    , data_criacao
    , id_tipo_pack_virtual
    , tipo_pack_virtual
    , limite_promocao_por_cupom
    , nivel_aplicacao
    , indicador
    , id_item
    , cod_agrupamento
    , leve
    , ganhe
    , valor
    , tipo_aplicacao
    , valor_aplicacao_pack
    , pertence_scanntech
    , desativado
    , modificado
  ) 
  SELECT tbppv.id_pack_virtual
       , tbppv.descricao
       , tbppv.data_inicial
       , tbppv.data_final
       , tbppv.data_criacao
       , tbppv.id_tipo_pack_virtual
       , tbppv.tipo_pack_virtual
       , tbppv.limite_promocao_por_cupom
       , tbppv.nivel_aplicacao
       , tbppv.indicador
       , tbppv.id_item
       , tbppv.cod_agrupamento
       , tbppv.leve
       , tbppv.ganhe
       , tbppv.valor
       , tipo_aplicacao
       , valor_aplicacao_pack
       , tbppv.pertence_scanntech
       , null AS desativado
       , true AS modificado
  FROM tbPromocaoPackVirtualTemp AS tbppv;
  
  /*Excluir tabela temporária*/
  DROP TABLE tbPromocaoPackVirtualTemp;
  
  RETURN TRUE;
END;
$$  LANGUAGE plpgsql;