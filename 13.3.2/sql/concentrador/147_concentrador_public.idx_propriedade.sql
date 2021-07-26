CREATE INDEX IF NOT EXISTS idx_propriedade_nome
    ON public.propriedade(nome);

CREATE INDEX IF NOT EXISTS idx_propriedade_idgrupopropriedade
    ON public.propriedade(idgrupopropriedade);