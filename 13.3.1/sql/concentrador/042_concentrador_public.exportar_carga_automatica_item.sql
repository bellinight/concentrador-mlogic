DROP FUNCTION IF EXISTS public.exportar_carga_automatica_item();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_item()
RETURNS TABLE (
    id INTEGER
  , nome VARCHAR
  , preco DECIMAL(18,4)
  , peso_variavel BOOLEAN
  , tributacao VARCHAR
  , cestabasica BOOLEAN
  , departamento INTEGER
  , desativado DATE
  , unidade INTEGER
  , desconto DECIMAL(18,4)
  , estoque DECIMAL(18,4)
  , tipoproducao VARCHAR
  , arrendondamentotruncamento VARCHAR
  , precocusto DECIMAL(18,4)
  , dataestoque DATE
  , aliquotafederal DECIMAL(18,4)
  , aliquotaestadual DECIMAL(18,4)
  , aliquotamunicipal DECIMAL(18,4)
  , ncm VARCHAR
  , cst_pis VARCHAR
  , cst_cofins VARCHAR
  , cst_icms VARCHAR
  , origem_icms VARCHAR
  , aliquota_icms  DECIMAL(15,4)
  , codigo_cest VARCHAR
  , descricao VARCHAR
  , percentual_fcp DECIMAL(18,4)
  , percentual_reducao DECIMAL(18,4)
  , industrializado BOOLEAN
  , cod_motivo_icms_desonerado INTEGER
  , aliquota_icms_desonerado DECIMAL(18,4)
  , perc_diferimento_icms DECIMAL(18,4)
  , base_icms_desonerado_imposto_embutido BOOLEAN
  , conceder_desconto_icms_desonerado BOOLEAN
  , cod_beneficio_fiscal VARCHAR
  , codigo_anp INTEGER
  , descricao_anp VARCHAR
  , perc_derivado_petroleo DECIMAL(18,4)
  , perc_gas_natural_nacional DECIMAL(18,4)
  , perc_gas_natural_importado DECIMAL(18,4)
  , codif VARCHAR
)
AS $$
BEGIN
  RETURN QUERY
  SELECT i.id
       , i.nome
       , i.preco
       , i.peso_variavel
       , i.tributacao
       , i.cestabasica
       , i.departamento
       , i.desativado
       , i.unidade
       , i.desconto
       , i.estoque
       , i.tipoproducao
       , i.arrendondamentotruncamento
       , i.precocusto
       , i.dataestoque
       , i.aliquotafederal
       , i.aliquotaestadual
       , i.aliquotamunicipal
       , i.ncm
       , i.cst_pis
       , i.cst_cofins
       , i.cst_icms
       , i.origem_icms
       , i.aliquota_icms
       , i.codigo_cest
       , i.descricao
       , i.percentual_fcp
       , i.percentual_reducao
       , i.industrializado
       , i.cod_motivo_icms_desonerado
       , i.aliquota_icms_desonerado
       , i.perc_diferimento_icms
       , i.base_icms_desonerado_imposto_embutido
       , i.conceder_desconto_icms_desonerado
       , i.cod_beneficio_fiscal
       , i.codigo_anp
       , i.descricao_anp
       , i.perc_derivado_petroleo
       , i.perc_gas_natural_nacional
       , i.perc_gas_natural_importado
       , i.codif 
    FROM item i
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;