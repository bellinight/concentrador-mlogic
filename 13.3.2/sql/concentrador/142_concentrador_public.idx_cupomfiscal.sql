CREATE INDEX IF NOT EXISTS idx_cupomfiscal_idsessao
    ON public.cupomfiscal (idsessao);

CREATE INDEX IF NOT EXISTS idx_cupomfiscal_dataabertura
    ON public.cupomfiscal (dataabertura);

CREATE INDEX IF NOT EXISTS idx_cupomfiscal_ccf
    ON public.cupomfiscal (ccf);

CREATE INDEX IF NOT EXISTS idx_cupomfiscal_serie
    ON public.cupomfiscal (serieecf);