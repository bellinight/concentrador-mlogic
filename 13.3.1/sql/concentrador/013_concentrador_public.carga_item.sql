/*
 * Esta função realiza a gravação dos ITENS no banco de dados do Concentrador.
 */
CREATE OR REPLACE FUNCTION public.carga_item(p_dados JSON) 
RETURNS BOOLEAN AS $$

BEGIN
   /*EXCLUI A TABELA TEMPORÁRIA SE EXISTE*/
   DROP TABLE IF EXISTS tbItemTemp;
   /*TABELA TEMPORÁRIA*/
    CREATE TEMPORARY TABLE tbItemTemp ( 
       id                                   INTEGER NOT NULL, 
       departamento                         INTEGER NOT NULL, 
       tributacao                           VARCHAR, 
       unidade                              INTEGER NOT NULL, 
       nome                                 VARCHAR NOT NULL, 
       preco                                NUMERIC(18,4) NOT NULL, 
       precocusto                           NUMERIC(18,4), 
       peso_variavel                        BOOLEAN, 
       cestabasica                          BOOLEAN, 
       desconto                             NUMERIC(18,4), 
       estoque                              NUMERIC(18,4), 
       tipoproducao                         CHAR NOT NULL, 
       arrendondamentotruncamento           CHAR NOT NULL, 
       aliquotafederal                     NUMERIC(18,4), 
       aliquotaestadual                     NUMERIC(18,4), 
       aliquotamunicipal                     NUMERIC(18,4), 
       ncm                                  VARCHAR NOT NULL, 
       cst_pis                              VARCHAR NOT NULL, 
       cst_cofins                           VARCHAR NOT NULL, 
       origem_icms                          VARCHAR NOT NULL, 
       cst_icms                             VARCHAR NOT NULL, 
       aliquota_icms                        NUMERIC(15,4) NOT NULL, 
       codigo_cest                          VARCHAR, 
       descricao                            VARCHAR NOT NULL, 
       percentual_fcp                       NUMERIC(18,4), 
       percentual_reducao                   NUMERIC(18,4), 
       industrializado                      BOOLEAN,
       cod_motivo_icms_desonerado             INTEGER,
       aliquota_icms_desonerado             NUMERIC(18,4),
       perc_diferimento_icms                NUMERIC(18,4),
       base_icms_desonerado_imposto_embutido    BOOLEAN,
       conceder_desconto_icms_desonerado        BOOLEAN,
       cod_beneficio_fiscal                     VARCHAR,
       codigo_anp                             INTEGER,
       descricao_anp                          VARCHAR,
       perc_derivado_petroleo                 NUMERIC(18,4),
       perc_gas_natural_nacional              NUMERIC(18,4),
       perc_gas_natural_importado             NUMERIC(18,4),
       codif                                  VARCHAR
   );
   /*INSERE OS DADOS NA TABELA TEMPORÁRIA A PARTIR DE UM JSON
   *
   *Exemplo do JSON recebido:
   *[{"id":34930,"departamento":1,"tributacao":"18","unidade":1,"nome":"PO R.FRISCO TANGERIN","preco":0.95,"precocusto":0.66,"peso_variavel":false,"cestabasica":false,"desconto":0.0,"estoque":1401.0,"tipoproducao":"T","arrendondamentotruncamento":"T","aliquotafederal":25.73,"aliquotaestadual":18.0,"aliquotamunicipal":0.0,"ncm":"21069010","cst_pis":"01","cst_cofins":"01","origem_icms":"0","cst_icms":"00","aliquota_icms":18.0,"codigo_cest":null,"descricao":"PO P/REFRESCO FRISCO TANGERINA 25g","percentual_fcp":0.0,"percentual_reducao":0.0,"industrializado":false,"cod_motivo_icms_desonerado":-1,"aliquota_icms_desonerado":0.0,"perc_diferimento_icms":0.0,"base_icms_desonerado_imposto_embutido":false,"conceder_desconto_icms_desonerado":false,"cod_beneficio_fiscal":"","codigo_anp":-1,"descricao_anp":"","perc_derivado_petroleo":0.0,"perc_gas_natural_nacional":0.0,"perc_gas_natural_importado":0.0,"codif":""}]
  *
  */      
   INSERT INTO tbItemTemp
      SELECT * FROM json_populate_recordset(NULL::tbItemTemp, p_dados);
   /*QUANDO ALGUM ITEM FOR INSERIDO*/
   INSERT INTO item 
       SELECT tb1.id, 
       tb1.departamento, 
       aliquota.id AS tributacao, 
       tb1.unidade, 
       SUBSTRING(tb1.nome, 1, 50), 
       tb1.preco, 
       tb1.precocusto, 
       tb1.peso_variavel, 
       tb1.cestabasica, 
       true AS modificado, 
       null AS desativado, 
       tb1.desconto, 
       tb1.estoque, 
       SUBSTRING(tb1.tipoproducao, 1, 1), 
       SUBSTRING(tb1.arrendondamentotruncamento, 1, 1), 
       null AS dataestoque, 
       md5('pi') as md5_p2, 
       tb1.aliquotafederal, 
       tb1.aliquotaestadual, 
       tb1.aliquotamunicipal, 
       tb1.ncm, tb1.cst_pis, tb1.cst_cofins, 
       tb1.origem_icms, tb1.cst_icms, tb1.aliquota_icms, tb1.codigo_cest, 
       tb1.descricao, 
       tb1.percentual_fcp, 
       tb1.percentual_reducao, 
       tb1.industrializado,
       tb1.cod_motivo_icms_desonerado,
       tb1.aliquota_icms_desonerado,
       tb1.perc_diferimento_icms,
       tb1.base_icms_desonerado_imposto_embutido,
       tb1.conceder_desconto_icms_desonerado,
       tb1.cod_beneficio_fiscal,
       tb1.codigo_anp,
       tb1.descricao_anp,
       tb1.perc_derivado_petroleo,
       tb1.perc_gas_natural_nacional,
       tb1.perc_gas_natural_importado,
       tb1.codif
   FROM tbitemtemp AS tb1 
         LEFT JOIN aliquota ON aliquota.idaliquotaorigem = SUBSTRING(tb1.tributacao, 1, 3) 
         LEFT JOIN item AS item  ON item.id = tb1.id 
    WHERE item.id IS NULL;
   /*QUANDO ALGUM ITEM JÁ EXISTENTE FOR ATIVADO*/
   UPDATE item SET departamento = tb1.departamento, 
       tributacao = aliquota.id, 
       unidade = tb1.unidade, 
       nome = SUBSTRING(tb1.nome, 1, 50), 
       preco = tb1.preco, 
       precocusto = tb1.precocusto, 
       peso_variavel = tb1.peso_variavel, 
       cestabasica = tb1.cestabasica, 
       modificado = true, 
       desativado = null, 
       desconto = tb1.desconto, 
       estoque = tb1.estoque, 
       tipoproducao = SUBSTRING(tb1.tipoproducao, 1, 1), 
       arrendondamentotruncamento = SUBSTRING(tb1.arrendondamentotruncamento, 1, 1), 
       dataestoque = null, 
       aliquotafederal = tb1.aliquotafederal, 
       aliquotaestadual = tb1.aliquotaestadual, 
       aliquotamunicipal= tb1.aliquotamunicipal, 
       ncm = tb1.ncm, cst_pis = tb1.cst_pis, cst_cofins = tb1.cst_cofins, 
       origem_icms = tb1.origem_icms, cst_icms = tb1.cst_icms, aliquota_icms = tb1.aliquota_icms, 
       md5_p2 = md5('pi'), codigo_cest = tb1.codigo_cest, 
       descricao = tb1.descricao, 
       percentual_fcp = tb1.percentual_fcp, 
       percentual_reducao = tb1.percentual_reducao, 
       industrializado = tb1.industrializado,
       cod_motivo_icms_desonerado = tb1.cod_motivo_icms_desonerado,
       aliquota_icms_desonerado = tb1.aliquota_icms_desonerado,
       perc_diferimento_icms = tb1.perc_diferimento_icms,
       base_icms_desonerado_imposto_embutido = tb1.base_icms_desonerado_imposto_embutido,
       conceder_desconto_icms_desonerado = tb1.conceder_desconto_icms_desonerado,
       cod_beneficio_fiscal = tb1.cod_beneficio_fiscal,
       codigo_anp = tb1.codigo_anp,
       descricao_anp = tb1.descricao_anp,
       perc_derivado_petroleo = tb1.perc_derivado_petroleo,
       perc_gas_natural_nacional = tb1.perc_gas_natural_nacional,
       perc_gas_natural_importado = tb1.perc_gas_natural_importado,
       codif = tb1.codif
     FROM tbItemTemp tb1 
     LEFT JOIN aliquota ON aliquota.idaliquotaorigem = SUBSTRING(tb1.tributacao, 1, 3) 
    WHERE item.id = tb1.id;
   /*QUANDO ALGUM ITEM FOR EXCLUÍDO*/
   UPDATE item 
   SET desativado = CURRENT_DATE, md5_p2 = md5('pi') 
    FROM (SELECT item.id FROM item 
          LEFT JOIN tbItemTemp AS tb1 ON tb1.id = item.id 
         WHERE tb1.id IS NULL AND item.desativado IS NULL ) AS tb1 
    WHERE tb1.id = item.id;
   /*EXCLUI A TABELA TEMPORÁRIA*/        
   DROP TABLE tbItemTemp;
   
   RETURN TRUE;
END;
$$  LANGUAGE plpgsql;