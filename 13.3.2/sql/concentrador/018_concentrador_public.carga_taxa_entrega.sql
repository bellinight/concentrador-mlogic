/*
 * Esta função realiza a gravação das Taxas de Entrega no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_taxa_entrega(p_dados JSON)
RETURNS BOOLEAN AS $$

BEGIN
  /*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
  DROP TABLE IF EXISTS tbTaxaDeEntregaTemp;
  /*TABELA TEMPORÁRIA*/
  CREATE TEMPORARY TABLE tbTaxaDeEntregaTemp (
         id INTEGER
       , descricao VARCHAR
       , valor NUMERIC(18,4));
  /*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/
  INSERT INTO tbTaxaDeEntregaTemp
  SELECT * FROM json_populate_recordset(NULL::tbTaxaDeEntregaTemp, p_dados);
  /*QUANDO ALGUMA TAXA DE ENTREGA FOR INSERIDA*/
  INSERT INTO taxa_entrega
  SELECT tbTemp.id AS id
       , tbTemp.descricao AS descricao
       , tbTemp.valor AS valor
       , null AS desativado
       , false AS modificado
   FROM tbTaxaDeEntregaTemp AS tbTemp
   LEFT JOIN taxa_entrega AS taxa ON taxa.id = tbTemp.id
  WHERE taxa.id IS NULL;
  /*QUANDO ALGUMA TAXA DE ENTREGA JÁ EXISTENTE FOR ATIVADA*/
  UPDATE taxa_entrega
     SET id = tbTemp.id
       , descricao = tbTemp.descricao
       , valor = tbTemp.valor
       , desativado = null
       , modificado = true
   FROM tbTaxaDeEntregaTemp AS tbTemp
  WHERE taxa_entrega.id = tbTemp.id;
  /*QUANDO ALGUMA TAXA DE ENTREGA FOR EXCLUÍDA*/
  UPDATE taxa_entrega
     SET desativado = CURRENT_DATE
       , modificado = true
    FROM (SELECT taxa_entrega.id FROM taxa_entrega
            LEFT JOIN tbTaxaDeEntregaTemp AS tbTemp ON tbTemp.id = taxa_entrega.id
           WHERE tbTemp.id IS NULL
             AND taxa_entrega.desativado IS NULL
         ) AS tbTemp
   WHERE tbTemp.id = taxa_entrega.id;
  /*EXCLUI A TABELA TEMPORÁRIA*/
  DROP TABLE tbTaxaDeEntregaTemp;

  RETURN TRUE;
END;
$$  LANGUAGE plpgsql;