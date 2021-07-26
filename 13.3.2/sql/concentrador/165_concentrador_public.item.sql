UPDATE public.item SET aliquotafederal = 0.0000 WHERE aliquotafederal IS NULL;
UPDATE public.item SET aliquotaestadual = 0.0000 WHERE aliquotaestadual IS NULL;
UPDATE public.item SET aliquotamunicipal = 0.0000 WHERE aliquotamunicipal IS NULL;
UPDATE public.item SET aliquota_icms = 0.0000 WHERE aliquota_icms IS NULL;
UPDATE public.item SET percentual_fcp = 0.0000 WHERE percentual_fcp IS NULL;
UPDATE public.item SET percentual_reducao = 0.0000 WHERE percentual_reducao IS NULL;
UPDATE public.item SET cod_motivo_icms_desonerado = -1 WHERE cod_motivo_icms_desonerado IS NULL;
UPDATE public.item SET aliquota_icms_desonerado = 0.0000 WHERE aliquota_icms_desonerado IS NULL;
UPDATE public.item SET perc_diferimento_icms = 0.0000 WHERE perc_diferimento_icms IS NULL;
UPDATE public.item SET base_icms_desonerado_imposto_embutido = false WHERE base_icms_desonerado_imposto_embutido IS NULL;
UPDATE public.item SET conceder_desconto_icms_desonerado = false WHERE conceder_desconto_icms_desonerado IS NULL;
UPDATE public.item SET codigo_anp = -1 WHERE codigo_anp IS NULL;
UPDATE public.item SET perc_derivado_petroleo = 0.0000 WHERE perc_derivado_petroleo IS NULL;
UPDATE public.item SET perc_gas_natural_nacional = 0.0000 WHERE perc_gas_natural_nacional IS NULL;
UPDATE public.item SET perc_gas_natural_importado = 0.0000 WHERE perc_gas_natural_importado IS NULL;

ALTER TABLE public.item 
      ALTER COLUMN aliquotafederal SET DEFAULT 0.0000
    , ALTER COLUMN aliquotafederal SET NOT NULL
    , ALTER COLUMN aliquotaestadual SET DEFAULT 0.0000
    , ALTER COLUMN aliquotaestadual SET NOT NULL
    , ALTER COLUMN aliquotamunicipal SET DEFAULT 0.0000
    , ALTER COLUMN aliquotamunicipal SET NOT NULL
    , ALTER COLUMN aliquota_icms SET DEFAULT 0.0000
    , ALTER COLUMN aliquota_icms SET NOT NULL
    , ALTER COLUMN percentual_fcp SET DEFAULT 0.0000
    , ALTER COLUMN percentual_fcp SET NOT NULL
    , ALTER COLUMN percentual_reducao SET DEFAULT 0.0000
    , ALTER COLUMN percentual_reducao SET NOT NULL
    , ALTER COLUMN cod_motivo_icms_desonerado SET DEFAULT -1
    , ALTER COLUMN cod_motivo_icms_desonerado SET NOT NULL
    , ALTER COLUMN aliquota_icms_desonerado SET DEFAULT 0.0000
    , ALTER COLUMN aliquota_icms_desonerado SET NOT NULL
    , ALTER COLUMN perc_diferimento_icms SET DEFAULT 0.0000
    , ALTER COLUMN perc_diferimento_icms SET NOT NULL
    , ALTER COLUMN base_icms_desonerado_imposto_embutido SET DEFAULT FALSE
    , ALTER COLUMN base_icms_desonerado_imposto_embutido SET NOT NULL
    , ALTER COLUMN conceder_desconto_icms_desonerado SET DEFAULT FALSE
    , ALTER COLUMN conceder_desconto_icms_desonerado SET NOT NULL
    , ALTER COLUMN codigo_anp SET DEFAULT -1
    , ALTER COLUMN codigo_anp SET NOT NULL
    , ALTER COLUMN perc_derivado_petroleo SET DEFAULT 0.0000
    , ALTER COLUMN perc_derivado_petroleo SET NOT NULL
    , ALTER COLUMN perc_gas_natural_nacional SET DEFAULT 0.0000
    , ALTER COLUMN perc_gas_natural_nacional SET NOT NULL
    , ALTER COLUMN perc_gas_natural_importado SET DEFAULT 0.0000
    , ALTER COLUMN perc_gas_natural_importado SET NOT NULL;