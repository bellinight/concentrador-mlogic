CREATE INDEX IF NOT EXISTS idx_itemcupomfiscal_iditem
    ON public.itemcupomfiscal (iditem);

CREATE INDEX IF NOT EXISTS idx_itemcupomfiscal_idcupomfiscal
    ON public.itemcupomfiscal (idcupomfiscal);

CREATE INDEX IF NOT EXISTS idx_itemcupomfiscal_idsessao
    ON public.itemcupomfiscal (idsessao);

CREATE INDEX IF NOT EXISTS idx_itemcupomfiscal_codigo
    ON public.itemcupomfiscal (codigo);