/*
 * Esta função realiza a gravação de um bloqueio sessão.
 */
DROP FUNCTION IF EXISTS public.persiste_bloqueio_sessao;
CREATE OR REPLACE FUNCTION public.persiste_bloqueio_sessao(
	p_id_sessao INTEGER,
	p_data_inicio TIMESTAMP,
	p_data_fim TIMESTAMP,
	p_codigo INTEGER,
	p_modificado BOOLEAN,
	p_numero_loja_sessao INTEGER,
	p_id_pdv_sessao INTEGER,
	p_abertura_sessao TIMESTAMP,
	p_id_usuario_desbloqueio INTEGER) 
RETURNS void AS $$

DECLARE id_bloqueio_sessao INTEGER;
DECLARE id_sessao INTEGER;
BEGIN
 id_sessao = busca_sessao(p_numero_loja_sessao, p_id_pdv_sessao, p_id_sessao, p_abertura_sessao);
 id_bloqueio_sessao = busca_bloqueio_sessao(id_sessao, p_codigo);
                 
 IF (id_bloqueio_sessao > 0) THEN
 
   UPDATE bloqueiosessao
	  SET datafim = p_data_fim,
	  idusuariodesbloqueio = p_id_usuario_desbloqueio
    WHERE idsessao = id_sessao
	  AND codigo = p_codigo
	  AND datainicio = p_data_inicio;
	     
 ELSE
  INSERT INTO bloqueiosessao
   (idsessao,
   datainicio,
   datafim,
   codigo,
   modificado)
  VALUES (id_sessao,
   p_data_inicio,
   p_data_fim,
   p_codigo,
   p_modificado);
 END IF;
END;
$$  LANGUAGE plpgsql;

