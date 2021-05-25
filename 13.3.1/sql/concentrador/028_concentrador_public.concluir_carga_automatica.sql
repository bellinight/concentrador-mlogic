CREATE OR REPLACE FUNCTION public.concluir_carga_automatica()
RETURNS TABLE (
    id_carga INTEGER
  , descricao_carga VARCHAR(50)
)
AS $$
DECLARE
  v_ultimo_id INTEGER;
  v_sequencia INTEGER;
BEGIN
  SELECT COALESCE(MAX(id) + 1, 1)
    INTO v_ultimo_id
    FROM atualizacao;

  SELECT COALESCE(MAX(sequencia) + 1, 1)
    INTO v_sequencia
    FROM atualizacao
   WHERE desativado IS NULL 
     AND data = CURRENT_DATE;

  INSERT INTO public.atualizacao(
         id
       , sequencia
       , data
       , total
       , desativado
       , descricao
       , modificado
       , idusuario
       , tipo
  )
  VALUES (
         v_ultimo_id
       , v_sequencia
       , CURRENT_DATE
       , TRUE
       , NULL
       , (SELECT TO_CHAR(NOW(),'DDMMYYYY HH24:MI')::VARCHAR)
       , TRUE
       , NULL
       , 'D'
  );
  
  PERFORM SETVAL('atualizacao_id_seq', v_ultimo_id, true);

  RETURN QUERY
  SELECT id as id_carga
       , descricao as descricao_carga
    FROM public.atualizacao
   WHERE id = v_ultimo_id;
END;
$$  LANGUAGE plpgsql;
