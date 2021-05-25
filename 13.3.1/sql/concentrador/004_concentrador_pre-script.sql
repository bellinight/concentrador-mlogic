UPDATE public.configuracao SET valor = false WHERE chave IN ('validacao.envio.prevenda.mq.automatico', 'exibir.checkbox.pre-venda');

DROP FUNCTION IF EXISTS public.bytea_import(p_path TEXT, p_result OUT bytea);
DROP FUNCTION IF EXISTS public.ler_configuracao_director();
DROP FUNCTION IF EXISTS public.busca_item_prevenda(p_id_prevenda INTEGER, p_codigoitem INTEGER);
DROP FUNCTION IF EXISTS public.persiste_item_prevenda(p_codigopedido INTEGER, p_codigoitem INTEGER, p_precounitario NUMERIC, p_quantidade NUMERIC, p_valortotal NUMERIC, p_desconto NUMERIC, p_valorliquido NUMERIC, p_desativado BOOLEAN);
DROP FUNCTION IF EXISTS public.busca_prevenda(p_codigopedido INTEGER);
DROP FUNCTION IF EXISTS public.persiste_prevenda(p_codigopedido INTEGER, p_codigocliente INTEGER, p_consumidor_final BOOLEAN, p_status CHARACTER VARYING, p_desativado BOOLEAN);
DROP FUNCTION IF EXISTS public.processar_prevenda(p_numeroprevenda INTEGER, p_isnumerodirector BOOLEAN);

DROP SCHEMA IF EXISTS director CASCADE;
DROP EXTENSION IF EXISTS odbc_fdw CASCADE;

DROP TABLE IF EXISTS public.itemprevenda;
DROP TABLE IF EXISTS public.prevenda;