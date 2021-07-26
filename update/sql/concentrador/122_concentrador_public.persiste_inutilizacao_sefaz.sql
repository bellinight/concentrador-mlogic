DROP FUNCTION IF EXISTS public.persiste_inutilizacao_sefaz;
CREATE OR REPLACE FUNCTION persiste_inutilizacao_sefaz (
       p_chave VARCHAR(50)
     , p_situacao CHAR(1)
     , p_ambiente INTEGER
     , p_serie INTEGER
     , p_numero_inicial INTEGER
     , p_numero_final INTEGER
     , p_status INTEGER
     , p_mensagem VARCHAR(400)
     , p_dh_inutilizacao TIMESTAMP
     , p_protocolo VARCHAR(400)
     , p_xml_gerado TEXT
     , p_exportado BOOLEAN
     , situacao_integracao CHAR(1)
     )
RETURNS void AS $$

BEGIN
  IF (busca_inutilizacao_sefaz(p_serie, p_ambiente, p_numero_inicial, p_numero_final) = FALSE)
  THEN
    INSERT INTO inutilizacao_sefaz (
           chave
         , situacao
         , ambiente
         , serie
         , numero_inicial
         , numero_final
         , status
         , mensagem
         , dh_inutilizacao
         , protocolo
         , xml_gerado
         , exportado
         , situacao_integracao
    )
    VALUES (
           p_chave
         , p_situacao
         , p_ambiente
         , p_serie
         , p_numero_inicial
         , p_numero_final
         , p_status
         , p_mensagem
         , p_dh_inutilizacao
         , p_protocolo
         , p_xml_gerado
         , p_exportado
         , situacao_integracao
    );
  END IF;
END;
$$  LANGUAGE plpgsql;