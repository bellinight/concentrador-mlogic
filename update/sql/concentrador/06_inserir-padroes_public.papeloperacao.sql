--depende de: public.papel
--ATENÇAO AO MODIFICAR: Inserir padrões somente para bancos limpos
DO $$ 
<<inserir_papel_operacao_padrao_para_operador>>
DECLARE
v_id_papel_operador BIGINT;
BEGIN
  v_id_papel_operador = 1; 
  IF (SELECT EXISTS(SELECT 1 FROM public.papeloperacao WHERE IDPAPEL = v_id_papel_operador)) THEN
     RETURN;
  END IF; 
  INSERT INTO public.papeloperacao (idoperacao, idpapel, modificado)
  VALUES 
       (1, v_id_papel_operador, false)
     , (7, v_id_papel_operador, false)
     , (39, v_id_papel_operador, false)
     , (37, v_id_papel_operador, false)
     , (121, v_id_papel_operador, false)
     , (22, v_id_papel_operador, false)
     , (120, v_id_papel_operador, false)
     , (133, v_id_papel_operador, false)
     , (50, v_id_papel_operador, false)
     , (103, v_id_papel_operador, false)
     , (106, v_id_papel_operador, false)
     , (30, v_id_papel_operador, false)
     , (101, v_id_papel_operador, false)
     , (102, v_id_papel_operador, false)
     , (41, v_id_papel_operador, false)
     , (112, v_id_papel_operador, false)
     , (38, v_id_papel_operador, false)
     , (125, v_id_papel_operador, false)
     , (123, v_id_papel_operador, false)
     , (23, v_id_papel_operador, false)
     , (5, v_id_papel_operador, false)
     , (131, v_id_papel_operador, false)
     , (127, v_id_papel_operador, false)
     , (53, v_id_papel_operador, false)
     , (55, v_id_papel_operador, false)
     , (54, v_id_papel_operador, false)
     , (31, v_id_papel_operador, false)
     , (56, v_id_papel_operador, false)
     , (57, v_id_papel_operador, false)
     , (73, v_id_papel_operador, false)
     , (118, v_id_papel_operador, false)
     , (14, v_id_papel_operador, false)
     , (15, v_id_papel_operador, false)
     , (67, v_id_papel_operador, false)
     , (16, v_id_papel_operador, false)
     , (109, v_id_papel_operador, false)
     , (35, v_id_papel_operador, false)
     , (36, v_id_papel_operador, false)
     , (68, v_id_papel_operador, false)
     , (69, v_id_papel_operador, false)
     , (92, v_id_papel_operador, false)
     , (108, v_id_papel_operador, false)
     , (21, v_id_papel_operador, false)
     , (25, v_id_papel_operador, false)
     , (12, v_id_papel_operador, false)
     , (10, v_id_papel_operador, false)
     , (26, v_id_papel_operador, false)
     , (93, v_id_papel_operador, false)
     , (148, v_id_papel_operador, false)
     , (150, v_id_papel_operador, false)
     , (145, v_id_papel_operador, false)
     , (58, v_id_papel_operador, false)
     , (28, v_id_papel_operador, false)
  ON CONFLICT (idoperacao, idpapel) DO NOTHING;
  PERFORM setval('papeloperacao_id_seq', (SELECT MAX(id) FROM public.papeloperacao));
END inserir_papel_operacao_padrao_para_operador $$;


DO $$ 
<<inserir_papel_operacao_padrao_para_fiscal>>
DECLARE
v_rec RECORD;
v_id_fiscal BIGINT;
BEGIN
  v_id_fiscal = 2;
  IF (SELECT EXISTS(SELECT 1 FROM public.papeloperacao WHERE IDPAPEL = v_id_fiscal)) THEN
     RETURN;
  END IF;   
  FOR v_rec IN    
     SELECT *
       FROM public.operacao O
      WHERE o.desativado IS NULL
        AND o.id NOT IN (4 /*FECHAMENTO DIÁRIO*/)
  LOOP
    INSERT INTO public.papeloperacao (idoperacao, idpapel, modificado)
    VALUES (v_rec.id, v_id_fiscal , false) ON CONFLICT (idoperacao, idpapel) DO NOTHING;
    PERFORM setval('papeloperacao_id_seq', (SELECT MAX(id) FROM public.papeloperacao));
  END LOOP;  
END inserir_papel_operacao_padrao_para_fiscal $$;


DO $$ 
<<inserir_papel_operacao_padrao_para_reducao>>
DECLARE
v_id_papel_reducao BIGINT;
BEGIN
  v_id_papel_reducao = 3;
  IF (SELECT EXISTS(SELECT 1 FROM public.papeloperacao WHERE IDPAPEL = v_id_papel_reducao)) THEN
     RETURN;
  END IF;  
  INSERT INTO public.papeloperacao (idoperacao, idpapel, modificado)
  VALUES 
       (120, v_id_papel_reducao, false)
     , (999, v_id_papel_reducao, false)
     , (4  , v_id_papel_reducao, false)
  ON CONFLICT (idoperacao, idpapel) DO NOTHING;
END inserir_papel_operacao_padrao_para_reducao $$;

SELECT setval('public.papeloperacao_id_seq'::regclass, (SELECT MAX(id) FROM public.papeloperacao));