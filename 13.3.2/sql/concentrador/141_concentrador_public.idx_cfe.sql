CREATE INDEX IF NOT EXISTS idx_cfe 
    ON public.cupom_fiscal_eletronico(cupom_fiscal);

CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronica_chave_eletronica
    ON public.cupom_fiscal_eletronico(chave_eletronica);

CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronica_dh_emissao
    ON public.cupom_fiscal_eletronico(dh_emissao);

CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronica_numero
    ON public.cupom_fiscal_eletronico(numero);

CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronica_serie
    ON public.cupom_fiscal_eletronico(serie);

CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronico_situacao_integracao
    ON public.cupom_fiscal_eletronico(situacao_integracao);
    
CREATE INDEX IF NOT EXISTS ix_cupom_fiscal_eletronico_ambiente
    ON public.cupom_fiscal_eletronico(ambiente);