/*
 * Esta função realiza a gravação das Faixas Promoção A partir de no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_faixa_preco_promocao_a_partir_de(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
    /*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
    DROP TABLE IF EXISTS tbFaixaPrecoPromocaoAPatirDeTemp;
    /*TABELA TEMPORÁRIA*/
     CREATE TEMPORARY TABLE tbFaixaPrecoPromocaoAPatirDeTemp (
            id_empresa INTEGER NOT NULL,
            id_item_principal INTEGER NOT NULL,
            quantidade NUMERIC(18,4) NOT NULL,
            desconto NUMERIC(18,4));
    /*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON*/
    INSERT INTO tbFaixaPrecoPromocaoAPatirDeTemp
        SELECT * FROM json_populate_recordset(NULL::tbFaixaPrecoPromocaoAPatirDeTemp, p_dados);
     /* DELETE para tratar registros com valor menor que zero*/
     DELETE FROM tbFaixaPrecoPromocaoAPatirDeTemp WHERE desconto <= 0;
     /*QUANDO ALGUMA FAIXA DE PREÇO DA PROMOÇÃO A PARTIR DE FOR INSERIDA*/
    INSERT INTO faixaprecopromocaolevepague
    SELECT tb1.id_empresa, tb1.id_item_principal, tb1.quantidade,
    tb1.desconto, null AS desativado, true AS modificado
         FROM tbFaixaPrecoPromocaoAPatirDeTemp AS tb1
         LEFT JOIN faixaprecopromocaolevepague AS faixaprecopromocaolevepague
         ON faixaprecopromocaolevepague.id_empresa = tb1.id_empresa
         AND faixaprecopromocaolevepague.id_item_principal = tb1.id_item_principal
         AND faixaprecopromocaolevepague.quantidade = tb1.quantidade
         WHERE faixaprecopromocaolevepague.id_empresa IS NULL
         AND faixaprecopromocaolevepague.id_item_principal IS NULL
         AND faixaprecopromocaolevepague.quantidade IS NULL;
    /*QUANDO ALGUMA FAIXA DE PREÇO DA PROMOÇÃO A PARTIR DE FOR ALTERADA*/
    UPDATE faixaprecopromocaolevepague
         SET desconto = tb1.desconto, desativado = null, modificado = true
         FROM tbFaixaPrecoPromocaoAPatirDeTemp tb1
         WHERE faixaprecopromocaolevepague.id_empresa = tb1.id_empresa
         AND faixaprecopromocaolevepague.id_item_principal = tb1.id_item_principal
         AND faixaprecopromocaolevepague.quantidade = tb1.quantidade;
     /*QUANDO ALGUMA FAIXA DE PREÇO DA PROMOÇÃO A PARTIR DE FOR EXCLUÍDA*/
    UPDATE faixaprecopromocaolevepague
    SET desativado = CURRENT_DATE
     FROM (SELECT faixaprecopromocaolevepague.id_empresa, faixaprecopromocaolevepague.id_item_principal,
            faixaprecopromocaolevepague.quantidade FROM faixaprecopromocaolevepague
            LEFT JOIN tbFaixaPrecoPromocaoAPatirDeTemp AS tb1
            ON tb1.id_empresa = faixaprecopromocaolevepague.id_empresa
            AND tb1.id_item_principal = faixaprecopromocaolevepague.id_item_principal
            AND tb1.quantidade = faixaprecopromocaolevepague.quantidade
            WHERE tb1.id_empresa IS NULL AND tb1.id_item_principal IS NULL
            AND tb1.quantidade IS NULL AND faixaprecopromocaolevepague.desativado IS NULL) AS tb1
            WHERE tb1.id_empresa = faixaprecopromocaolevepague.id_empresa
            AND tb1.id_item_principal = faixaprecopromocaolevepague.id_item_principal
            AND tb1.quantidade = faixaprecopromocaolevepague.quantidade;
    /*EXCLUI A TABELA TEMPORÁRIA*/          
    DROP TABLE tbFaixaPrecoPromocaoAPatirDeTemp;
    
    RETURN TRUE;
END;
$$  LANGUAGE plpgsql;