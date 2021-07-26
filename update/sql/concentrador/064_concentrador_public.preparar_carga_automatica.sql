CREATE OR REPLACE FUNCTION public.preparar_carga_automatica()
RETURNS TABLE (
  tabela VARCHAR(100)
)
AS $$
DECLARE
  v_modalidade_pack_virtual INTEGER;
  v_modalidade_campanha INTEGER;
  v_modalidade_apartirde INTEGER;
  v_modalidade_preco_promocional INTEGER;

BEGIN
  
  v_modalidade_pack_virtual := 1;
  v_modalidade_campanha := 2;
  v_modalidade_apartirde := 3;
  v_modalidade_preco_promocional := 4;

--PROMOÇÕES
UPDATE promocao
   SET desativado = NOW()
 WHERE datafim < NOW() AND desativado IS NULL;

UPDATE promocaolevepague
   SET desativado = NOW()
 WHERE datafim < NOW() AND desativado IS NULL;

UPDATE promocao_campanha
   SET desativado = NOW()
 WHERE data_final < NOW() AND desativado IS NULL;

UPDATE promocao_pack_virtual
   SET desativado = NOW()
 WHERE data_final < NOW() AND desativado IS NULL;

CREATE TEMPORARY TABLE tempPromocao (
    id SERIAL PRIMARY KEY
  , descricao VARCHAR(100) NOT NULL
  , data_inicio TIMESTAMP NOT NULL
  , data_fim TIMESTAMP NOT NULL
  , id_modalidade INTEGER NOT NULL
  , id_retaguarda BIGINT NOT NULL
);

--PREÇO PROMOCIONAL
INSERT INTO tempPromocao (
    descricao
  , data_inicio
  , data_fim
  , id_modalidade
  , id_retaguarda
)
SELECT nome
     , dataInicio
     , datafim
     , v_modalidade_preco_promocional AS id_modalidade
     , id AS id_retaguarda
  FROM promocao
 WHERE desativado IS NULL;

--A PARTIR DE
INSERT INTO tempPromocao (
    descricao
  , data_inicio
  , data_fim
  , id_modalidade
  , id_retaguarda
)
SELECT DISTINCT
       descricao
     , dataInicio
     , datafim
     , v_modalidade_apartirde AS id_modalidade
     , 0 AS id_retaguarda
  FROM promocaolevepague
 WHERE desativado IS NULL AND datafim > now();

--CAMPANHA
INSERT INTO tempPromocao (
      descricao
    , data_inicio
    , data_fim
    , id_modalidade
    , id_retaguarda
)
SELECT DISTINCT
       descricao
     , data_inicial
     , data_final
     , v_modalidade_campanha AS id_modalidade
     , id_campanha AS id_retaguarda
  FROM promocao_campanha;

--PACK VIRTUAL
INSERT INTO tempPromocao (
       descricao
     , data_inicio
     , data_fim
     , id_modalidade
     , id_retaguarda
)
SELECT DISTINCT
       descricao
     , data_inicial
     , data_final
     , v_modalidade_pack_virtual AS id_modalidade
     , id_pack_virtual AS id_retaguarda
  FROM promocao_pack_virtual;

--TABELA TEMPORÁRIA PARA OS DADOS DA TABELA PRINCIPAL 'PROMOCAO'
CREATE TEMPORARY TABLE tempDadosPromocao(
       id SERIAL PRIMARY KEY
     , id_promocao INTEGER NOT NULL
     , id_item INTEGER NOT NULL
     , prc_promo NUMERIC(18,4) NOT NULL
     , desconto NUMERIC(18,4) NOT NULL
     , qtde_promocional NUMERIC(18,4) NOT NULL
);

--PREÇO PROMOCIONAL
INSERT INTO tempDadosPromocao (
       id_promocao
     , id_item
     , prc_promo
     , desconto
     , qtde_promocional
)
SELECT DISTINCT
       tp.id
     , ip.iditem
     , ip.precopromocao AS prc_promo
     , (i.preco-ip.precopromocao) AS desconto
     , 1 AS qtde_promocional
  FROM tempPromocao tp
  JOIN itemPromocao ip
    ON tp.id_retaguarda = ip.idPromocao
  JOIN item i
    ON i.id = ip.iditem
 WHERE i.desativado IS NULL
   AND ip.desativado IS NULL
   AND (i.preco-ip.precopromocao) > 0
   AND id_modalidade = v_modalidade_preco_promocional;

--A PARTIR DE
INSERT INTO tempDadosPromocao (
       id_promocao
     , id_item
     , prc_promo
     , desconto
     , qtde_promocional
)
SELECT DISTINCT
       tp.id
     , pl.id_item_principal
     , (i.preco-fl.desconto) AS prc_promo
     , fl.desconto
     , fl.quantidade
  FROM tempPromocao tp
  JOIN promocaolevepague pl
    ON pl.datainicio = tp.data_inicio
   AND pl.datafim = tp.data_fim
   AND pl.desativado IS NULL
  JOIN faixaprecopromocaolevepague fl
    ON fl.id_item_principal = pl.id_item_principal
  JOIN item i
    ON i.id = fl.id_item_principal
 WHERE fl.desconto > 0
   AND i.desativado IS NULL
   AND fl.DESATIVADO IS NULL
   AND id_modalidade = v_modalidade_apartirde;

--CAMPANHA
INSERT INTO tempDadosPromocao (
       id_promocao
     , id_item
     , prc_promo
     , desconto
     , qtde_promocional
)
SELECT DISTINCT
       tp.id
     , pc.id_item
     , CASE WHEN tipo_valor_percentual THEN ROUND(i.preco-(i.preco*pc.valor/100),2) ELSE pc.valor END AS prc_promo
     , CASE WHEN tipo_valor_percentual THEN ROUND((i.preco*pc.valor/100),2) ELSE (i.preco-pc.valor) END AS desconto
     , 1 AS qtde_promocional
  FROM tempPromocao tp
  JOIN promocao_campanha pc
    ON pc.id_campanha = tp.id_retaguarda
  JOIN item i
    ON i.id = pc.id_item
   AND i.desativado IS NULL
 WHERE tp.id_modalidade = v_modalidade_campanha
   AND (tipo_valor_percentual AND ROUND(i.preco-(i.preco*pc.valor/100),2) > 0)
    OR (tipo_valor_percentual IS FALSE AND (i.preco-pc.valor) > 0);

--PACK VIRTUAL
CREATE TEMPORARY TABLE tempDadosPromocaoPackVirtual (
       id_promocao INTEGER NOT NULL
     , id_tipo_pack INTEGER NOT NULL
     , id_agrupamento INTEGER NOT NULL
     , id_item INTEGER NOT NULL
     , leve NUMERIC(18,4) NOT NULL
     , ganhe NUMERIC(18,4) NOT NULL
     , tipo_aplicacao INTEGER NOT NULL
     , nivel_aplicacao VARCHAR(1) NOT NULL
     , valor_aplicacao NUMERIC(18,4) NOT NULL
     , limite_aplicacao INTEGER NOT NULL
     , pertence_scanntech BOOLEAN
);

INSERT INTO tempDadosPromocaoPackVirtual (
SELECT tp.id_retaguarda
     , ppv.id_tipo_pack_virtual
     , ppv.cod_agrupamento AS id_agrupamento
     , ppv.id_item
     , ppv.leve
     , ppv.ganhe
     , ppv.tipo_aplicacao
     , ppv.nivel_aplicacao
     , ppv. valor AS valor_aplicacao
     , ppv.limite_promocao_por_cupom AS limite_aplicacao
     , ppv.pertence_scanntech
  FROM promocao_pack_virtual ppv
  JOIN tempPromocao tp ON tp.id_retaguarda = ppv.id_pack_virtual
 WHERE tp.id_modalidade = v_modalidade_pack_virtual
);

-- Retornando a lista de tabelas que devem ser integradas.
-- O exportador concatena o nome da tabela para formar o nome da procedure.
RETURN QUERY
SELECT CAST(REPLACE(routine_name, 'exportar_carga_automatica_', '') AS VARCHAR) AS tabela
  FROM information_schema.routines
 WHERE routine_name LIKE 'exportar_carga_automatica_%';
 
END;
$$  LANGUAGE plpgsql;
