DROP FUNCTION IF EXISTS public.persiste_conferencia_caixa;
CREATE OR REPLACE FUNCTION public.persiste_conferencia_caixa(
  p_id_pdv INTEGER,
  p_numero_loja INTEGER,
  p_codigo_sessao INTEGER, 
  p_abertura_sessao TIMESTAMP,
  p_valor_informado NUMERIC(18,2),
  p_valor_apurado NUMERIC(18,2),
  p_diferenca NUMERIC(18,2))
RETURNS void AS $$
DECLARE v_is_persistir BOOLEAN;
DECLARE v_id_sessao INTEGER;
BEGIN
  v_id_sessao := busca_sessao(p_numero_loja, p_id_pdv, p_codigo_sessao, p_abertura_sessao); 
  IF (v_id_sessao > 0) THEN
	  INSERT INTO conferencia_caixa(id_sessao, valor_informado, valor_apurado, diferenca)
	       VALUES (v_id_sessao, p_valor_informado, p_valor_apurado, p_diferenca)
	  ON CONFLICT (id_sessao) DO 
	   UPDATE SET valor_informado = p_valor_informado, valor_apurado = p_valor_apurado, diferenca = p_diferenca;
  END IF;
END;
$$ LANGUAGE plpgsql;

