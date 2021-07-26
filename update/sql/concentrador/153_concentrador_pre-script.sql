DROP TABLE IF EXISTS public.configuracaopafecf;
DROP TABLE IF EXISTS public.estoque_mensal_pafecf;
DROP TABLE IF EXISTS public.envio_fisco_pafecf_estoque;
DROP TABLE IF EXISTS public.envio_fisco_pafecf_reducaoz;
DROP TABLE IF EXISTS public.aliquotaespecificaecf;
DROP TABLE IF EXISTS public.formapagamentoespecificaecf;
DROP TABLE IF EXISTS public.paf_ecf;
DROP TABLE IF EXISTS public.historicopafecf;
DROP TABLE IF EXISTS public.estoquepafecf;
DROP TABLE IF EXISTS public.notafiscaleletronica;
DROP TABLE IF EXISTS public.totalizadorparcialreducaoz;
DROP TABLE IF EXISTS public.itemprevenda;
DROP TABLE IF EXISTS public.prevenda;

ALTER TABLE IF EXISTS public.perfilpdv
 DROP COLUMN IF EXISTS idgrupolayoutcheque;

ALTER TABLE IF EXISTS public.perfilpdv
 DROP COLUMN IF EXISTS idlayoutcheque;

DROP TABLE IF EXISTS public.layoutcheque;
DROP TABLE IF EXISTS public.grupolayoutcheque;

DROP TABLE IF EXISTS public.itemnotafiscal;
DROP TABLE IF EXISTS public.notavendaconsumidor;
DROP TABLE IF EXISTS public.notafiscal;

ALTER TABLE IF EXISTS public.empresadesenvolvedora
 DROP COLUMN IF EXISTS numerolaudo,
 DROP COLUMN IF EXISTS md5arquivoprincipal,
 DROP COLUMN IF EXISTS md5outrosarquivos,
 DROP COLUMN IF EXISTS versaoroteiro,
 DROP COLUMN IF EXISTS nomearquivoprincipal,
 DROP COLUMN IF EXISTS correcao_numero_laudo;


