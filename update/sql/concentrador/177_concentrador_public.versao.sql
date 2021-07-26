CREATE TABLE IF NOT EXISTS public.versao (
       id INTEGER NOT NULL
     , versao_sistema VARCHAR(20) NOT NULL
     , versao_script INTEGER NOT NULL
     , data_hora_atualizacao TIMESTAMP NOT NULL
     , CONSTRAINT versao_pkey PRIMARY KEY (id)
);

INSERT INTO public.versao (
       id
     , versao_sistema
     , versao_script
     , data_hora_atualizacao)
VALUES (
       1
     , '13.3.2'
     , 1
     , now()::timestamp(0))
    ON CONFLICT (id)
    DO UPDATE SET versao_script = '1';