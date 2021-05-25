DROP FUNCTION IF EXISTS exportar_carga_automatica_usuario();
CREATE OR REPLACE FUNCTION public.exportar_carga_automatica_usuario()
RETURNS TABLE (
     id INTEGER
   , nome VARCHAR
   , login VARCHAR
   , senha VARCHAR
   , nomereduzido VARCHAR
   , desativado DATE
   , digital TEXT
   , utiliza_cartao_magnetico BOOLEAN
   , codigo_cartao_magnetico VARCHAR
)
AS $$ 
BEGIN
  RETURN QUERY
  SELECT u.id
       , u.nome
       , u.login
       , u.senha
       , u.nomereduzido
       , u.desativado
       , u.digital
       , u.utiliza_cartao_magnetico
       , u.codigo_cartao_magnetico
    FROM usuario u
   ORDER BY 1;
END;
$$  LANGUAGE plpgsql;