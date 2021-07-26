CREATE TABLE IF NOT EXISTS public.conferencia_caixa(
  id SERIAL NOT NULL,
  id_sessao BIGINT NOT NULL,
  valor_informado NUMERIC(18,2),
  valor_apurado NUMERIC(18,2),
  diferenca NUMERIC(18,2),
  CONSTRAINT pk_conferencia_caixa_id PRIMARY KEY(id),
  CONSTRAINT unq_conferencia_caixa_id_sessao UNIQUE(id_sessao)
);