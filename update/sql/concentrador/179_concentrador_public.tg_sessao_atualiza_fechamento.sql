DROP TRIGGER IF EXISTS tg_sessao_atualiza_fechamento ON public.sessao;
CREATE OR REPLACE FUNCTION public.tf_sessao_atualizar_fechamento() 
RETURNS TRIGGER AS $tg_sessao_atualiza_fechamento$
BEGIN
  NEW.fechado = (NEW.fechamento IS NOT NULL);
  NEW.modificado = TRUE;
  RETURN NEW;
END;
$tg_sessao_atualiza_fechamento$ LANGUAGE plpgsql;

CREATE TRIGGER tg_sessao_atualiza_fechamento BEFORE INSERT OR UPDATE ON public.sessao
   FOR EACH ROW EXECUTE FUNCTION public.tf_sessao_atualizar_fechamento();