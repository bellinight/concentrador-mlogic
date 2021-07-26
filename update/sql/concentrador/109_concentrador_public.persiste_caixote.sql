----------------------------------------------------------
-- Esta função realiza a gravação dos dados do Caixote. --
----------------------------------------------------------
DROP FUNCTION IF EXISTS public.persiste_caixote;
CREATE OR REPLACE FUNCTION public.persiste_caixote(
  p_descricao VARCHAR
, p_ccf INTEGER
, p_serie VARCHAR
, p_coo INTEGER) 
RETURNS void AS $$
DECLARE 
  id_caixote INTEGER;
  id_cupom INTEGER;
  id_entrega_conc INTEGER;
BEGIN
  id_cupom = busca_cupom_fiscal(p_ccf, p_serie, p_coo);
  IF (id_cupom > 0)
  THEN
    id_entrega_conc = busca_entrega(id_cupom);
    IF (id_entrega_conc > 0)
    THEN
      id_caixote = busca_caixote(id_entrega_conc, p_descricao);
      IF (id_caixote IS NULL) 
      THEN
        INSERT INTO caixote 
          (id_entrega
          ,descricao) 
        VALUES	(id_entrega_conc
          ,p_descricao);
      ELSE
        UPDATE caixote
           SET id_entrega = id_entrega_conc
               ,descricao = p_descricao        
         WHERE	id = id_caixote; 
      END IF;
    END IF;
  END IF;
END;
$$  LANGUAGE plpgsql;