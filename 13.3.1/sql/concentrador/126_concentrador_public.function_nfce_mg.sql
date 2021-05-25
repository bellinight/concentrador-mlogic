--depende de: public.modulo11_CalcularDV

--SCHEMA XML VERSÃO 4.00--
DROP FUNCTION IF EXISTS public.function_nfce_mg;
CREATE OR REPLACE FUNCTION public.function_nfce_mg(p_idcupomfiscal integer, p_idempresa integer) RETURNS xml AS
$BODY$
  
    -----------------
    -- VERSÂO 4.00 --
    -----------------

  /* ----------------------------------------------------------------------
   * Para facilitar o entendimento do algoritmo, note que a função começa  
   * a preencher o xml a partir do nó filho subindo até o nó pai.       
   * Desta forma fica mais complexo o entendimento, porém indo de pai para  
   * filho a gente esbarra com o problema dos campos opcionais quando    
   * eles estão nulos no banco, pois a função gera a tag vazia, como por  
   * exemplo "<xCpl></xCpl>", o que não é permitido pela Sefaz        
   *                                    
   * No exemplo abaixo o agoritmo irá preencher:              
   * ----------------------------------------------------------------------
   *  1º: <cUF>
   *  2º: demais tags filhas de <ide>
   *  3º: finaliza a <ide>
   *  4º: <xLgr>
   *  5º: demais tags filhas de <enderEmit>
   *  6º: finaliza <enderEmit>
   *  7º: demais tags irmãs de <emit>
   *  Etc...
   * ----------------------------------------------------------------------
   *   <ide>
   * [1º]    <cUF>13</cUF>
   * [2º]    ...  
   * [3º]  </ide>
   *  <emit>
   * [7º]    <CNPJ>02547812000112</CNPJ>
   * [8º]    ...
   * [6º]    <enderEmit>
   * [4º]      <xLgr>AV CORONEL TEIXEIRA</xLgr>
   * [5º]      ...
   *    </enderEmit>
   * [9º]    ...
   * [10º]</emit>
   * ----------------------------------------------------------------------
   */

DECLARE
  v_itemcupom  itemcupomfiscal%ROWTYPE;

  v_empresa RECORD;
  v_cupomFiscal RECORD;
  v_cliente RECORD;
  v_det RECORD;
  v_pag RECORD;
  v_detPag RECORD;
  v_dados_cliente RECORD;
  v_dados_modalidade RECORD;
  v_ultimo_item RECORD;
  v_transportadora RECORD;
  v_consumidor_final RECORD;
  v_resultado RECORD;

  somatorioValorItens NUMERIC(15,2);
  somatorioValorBcICMS NUMERIC(15,2);
  somatorioValorICMS NUMERIC(15,2);
  somatorioValorPIS NUMERIC(15,2);
  somatorioValorCOFINS NUMERIC(15,2);
  somatorioValorDesc NUMERIC(15,2);
  somatorioTotalTributos NUMERIC(15,2);
  valorLiquidoTotalNFCe NUMERIC(15,2);
  somatorioValorFCP NUMERIC(15,2);
  somatorioValorICMSDeson NUMERIC(13,2);
  somatorioValorFrete NUMERIC(15,2);
  
  valorPIS NUMERIC(15,2);
  valorCOFINS NUMERIC(15,2);
  valorBcICMS NUMERIC(15,2);
  valorICMS NUMERIC(15,2);
  valorFCP NUMERIC(15,2);
  valorBcFCP NUMERIC(15,2);
  valorTotalTributos NUMERIC(15,2);
  valorBcICMSDesonerado NUMERIC(13,2);
  valorBcICMSDesonEmbutido NUMERIC(13,2);
  valorDiferencaFrete NUMERIC(13,2);

  cDV INTEGER;
  length_CGC INTEGER;
  chaveNFCe TEXT;
  nomeTipoCOFINS TEXT;
  nomeTipoPIS TEXT;
  nomeTipoICMS TEXT;
  utc TEXT;
  qrCode TEXT;
  urlChave TEXT;
  existeFcp BOOLEAN;
  informacoesAdicionais TEXT;
  modalidadeFrete INTEGER;
  valorTotalLiquidoDosItens NUMERIC(15,2);
  existeFrete BOOLEAN;
  efetuarRateioFrete BOOLEAN;
  tratarDescontoNoFrete BOOLEAN;
  quantidadeDeItensSuperiorAoRateio BOOLEAN;
  numeroDoItem INTEGER;
  consumidorFinal BOOLEAN;
  novaChaveAcesso INTEGER;
  consumidorObrigatorio BOOLEAN;

  tag_det_tmp XML;
  tag_det_pag_tmp XML;
  tag_tipo_ICMS XML;
  tag_tipo_PIS XML;
  tag_tipo_COFINS XML;

  tag_enviNFe XML;
    tag_NFe XML;
      tag_infNFe XML;
        tag_ide XML;
        tag_emit XML;
        tag_enderEmit XML;
        tag_dest XML;
        tag_enderDest XML;
        tag_det XML;
        tag_prod XML;
        tag_imposto XML;
        tag_total_tributos XML;
        tag_ICMS XML;
        tag_PIS XML;
        tag_COFINS XML;
        tag_total XML;
        tag_ICMSTot XML;
        tag_pag XML;
        tag_vTroco XML;
        tag_det_pag XML;
        tag_card XML;
        tag_infAdic XML;
        tag_infNFeSupl XML;
        tag_Signature XML;
        tag_transp XML;
        tag_transporta XML;
        tag_combo XML;
BEGIN  
  somatorioValorItens := 0;
  somatorioValorBcICMS := 0;
  somatorioValorICMS := 0;
  somatorioValorPIS := 0;
  somatorioValorCOFINS := 0;
  somatorioValorDesc := 0;
  somatorioTotalTributos := 0;
  somatorioValorFCP := 0;
  somatorioValorICMSDeson := 0;
  somatorioValorFrete := 0;
  tratarDescontoNoFrete := false;
  quantidadeDeItensSuperiorAoRateio := false;
  numeroDoItem := 0;
  consumidorFinal := false;
  consumidorObrigatorio := false;

  SELECT BTRIM(rua) AS xLgr
       , numero AS nro
       , BTRIM(complemento) AS xCpl
       , BTRIM(bairro) AS xBairro
       , codigoibge AS cMun
       , BTRIM(cidade) AS xMun
       , BTRIM(cod_ibge_uf) AS cUF
       , BTRIM(estado) AS UF
       , cep AS CEP
       , BTRIM(telefone) AS fone
       , BTRIM(cnpjceicpf) AS CNPJ
       , BTRIM(razaosocial) AS xNome
       , BTRIM(nomefantasia) AS xFant
       , BTRIM(inscricaoestadual) AS IE
       , BTRIM(regime_tributario) AS CRT
       , pis AS pPIS
       , cofins AS pCOFINS
    INTO v_empresa
    FROM public.empresa
   WHERE id = p_idEmpresa;

   SELECT SUM(totalliquido) AS total
     FROM public.itemcupomfiscal
     INTO valorTotalLiquidoDosItens
    WHERE idcupomfiscal = p_idcupomfiscal
      AND cancelado = false;
  ----------- 
  -- <NFe> --
  -----------
    ------------------- 
    -- <NFe><infNFe> --
    -------------------
      ------------------------
      -- <NFe><infNFe><ide> --
      ------------------------ 
      SELECT utc_offset INTO utc FROM pg_timezone_names WHERE name = 'America/Sao_Paulo';
      utc := SUBSTRING(utc FROM 0 for 7);
      
      SELECT cfe.id + 1 AS novoId
        INTO novaChaveAcesso
        FROM public.formapagamentoefetuada fpe
           , formapagamento fp
           , cupomfiscal cf
        LEFT JOIN public.cupom_fiscal_eletronico cfe ON cfe.cupom_fiscal = cf.id
       WHERE fpe.idforma = fp.id
         AND fpe.idcupom = cf.id 
         AND cf.id = p_idCupomFiscal;
      
      SELECT CASE WHEN LENGTH(novaChaveAcesso::VARCHAR) > 8 THEN
                  REPLACE(LPAD(novaChaveAcesso::VARCHAR, 8, '0'),' ','')
             ELSE
                  REPLACE(TO_CHAR(novaChaveAcesso,'00000000'),' ','')
             END AS cNF
           , cfe.serie AS serie
           , cfe.numero AS nNF
           , TO_CHAR(COALESCE(cfe.dh_emissao,CURRENT_TIMESTAMP), 'YYYY-MM-DD"T"HH24:MI:SS' || utc) AS dhEmi
           , TO_CHAR(COALESCE(cf.datafechamento,CURRENT_TIMESTAMP), 'YYMM') AS dhChaveNFCe
           , BTRIM(cfe.tipo_impressao) AS tpImp
           , BTRIM(cfe.cd_tipo_emissao) AS tpEmis
           , BTRIM(cfe.consumidor_final) AS indFinal
           , BTRIM(cfe.presencial) AS indPres
           , BTRIM(cfe.tipo_finalidade) AS finNFe
           , TO_CHAR(COALESCE(cfe.dh_contingencia,CURRENT_TIMESTAMP), 'YYYY-MM-DD"T"HH24:MI:SS' || utc) AS dhCont
           , BTRIM(cfe.justificativa) AS xJust
           , BTRIM(cfe.ambiente) AS tpAmb
           , BTRIM(cfe.versao_aplicativo) AS verProc
           , cf.idcliente AS cliente
           , BTRIM(cfe.observacao) AS infCpl
           , BTRIM(cfe.url_qrcode) AS qrCode
           , round(cf.troco, 2) AS valorTroco
           , round(cf.frete, 2) AS valorFrete

        INTO v_cupomFiscal
        FROM public.formapagamentoefetuada fpe
           , formapagamento fp
           , cupomfiscal cf
        LEFT JOIN public.cupom_fiscal_eletronico cfe ON cfe.cupom_fiscal = cf.id
       WHERE fpe.idforma = fp.id
         AND fpe.idcupom = cf.id 
         AND cf.id = p_idCupomFiscal;

      existeFrete :=  (v_cupomFiscal.valorFrete IS NOT NULL) AND (v_cupomFiscal.valorFrete > 0);

      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_empresa.cUF AS "cUF"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.cNF AS "cNF"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST('Venda de Mercadoria' AS "natOp"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST('65' AS "mod"));       --[65: NFCe]
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.serie AS "serie"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.nNF AS "nNF"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.dhEmi AS "dhEmi"));                
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST('1' AS "tpNF"));       --[1: saída]
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST('1' AS "idDest"));       --[1: interno]
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_empresa.cMun AS "cMunFG"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.tpImp AS "tpImp"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.tpEmis AS "tpEmis"));
        
      ---------------------------------------- 
      -- Gerando a chave eletrônica na NFCe --
      ----------------------------------------
      chaveNFCe := lpad(v_empresa.cUF, 2, '0');
      chaveNFCe := chaveNFCe || lpad(v_cupomfiscal.dhChaveNFCe, 4, '0');
      chaveNFCe := chaveNFCe || lpad(lpad(v_empresa.CNPJ,14), 14, '0');
      chaveNFCe := chaveNFCe || '65';
      chaveNFCe := chaveNFCe || lpad(v_cupomFiscal.serie::varchar, 3, '0');
      chaveNFCe := chaveNFCe || lpad(v_cupomFiscal.nNF::varchar, 9, '0');
      chaveNFCe := chaveNFCe || lpad(v_cupomFiscal.tpEmis, 1, '0');
      chaveNFCe := chaveNFCe || lpad(v_cupomFiscal.cNF, 8, '0');
      cDV := modulo11_CalcularDV(chaveNFCe);
      chaveNFCe := chaveNFCe || cDV;
      chaveNFCe := REPLACE(chaveNFCe, ' ', '');
      -----------------------------------------------
      -- Fim da geração a chave eletrônica na NFCe --
      -----------------------------------------------
       
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(cDV AS "cDV"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomfiscal.tpAmb AS "tpAmb"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.finNFe AS "finNFe"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.indFinal AS "indFinal"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.indPres AS "indPres"));
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST('0' AS "procEmi"));      --[0: emissão de NF-e com aplicativo do contribuinte] 
      tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.verProc AS "verProc"));  
        
      IF (v_cupomFiscal.tpEmis::text <> '1') 
      THEN
        tag_ide := XMLCONCAT(tag_ide, XMLFOREST(v_cupomFiscal.dhCont AS "dhCont"));
        tag_ide := XMLCONCAT(tag_ide, XMLFOREST(COALESCE(v_cupomFiscal.xJust, 'Problemas no servidor e/ou na rede') AS "xJust"));
      END IF;
      
      SELECT XMLELEMENT(name "ide" 
           ,tag_ide)
        INTO tag_ide;    
      -------------------------
      -- <NFe><infNFe></ide> --
      ------------------------- 
        
      -------------------------
      -- <NFe><infNFe><emit> --
      ------------------------- 
        ------------------------------------
        -- <NFe><infNFe><emit><enderEmit> --
        ------------------------------------ 
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.xLgr AS "xLgr"));
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.nro AS "nro"));
        
        IF (v_empresa.xCpl IS NOT NULL) AND (v_empresa.xCpl <> '') 
        THEN
          tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.xCpl AS "xCpl"));
        END IF;
          
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.xBairro AS "xBairro"));
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.cMun AS "cMun"));
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.xMun AS "xMun"));
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.UF AS "UF"));
        tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.CEP AS "CEP"));
          
        IF (v_empresa.fone IS NOT NULL) AND (v_empresa.fone <> '') 
        THEN
          tag_enderEmit := XMLCONCAT(tag_enderEmit, XMLFOREST(v_empresa.fone AS "fone"));
        END IF;
          
        SELECT XMLELEMENT (name "enderEmit" 
              ,tag_enderEmit)
          INTO tag_enderEmit;  
        -------------------------------------
        -- <NFe><infNFe><emit></enderEmit> --
        ------------------------------------- 
          
      SELECT XMLELEMENT(name "emit"
           ,XMLFOREST(v_empresa.CNPJ AS "CNPJ")
           ,XMLFOREST(v_empresa.xNome AS "xNome") 
           ,XMLFOREST(v_empresa.xFant AS "xFant") 
           ,tag_enderEmit
           ,XMLFOREST(REPLACE(v_empresa.IE,'.','') AS "IE")
           ,XMLFOREST(v_empresa.CRT AS "CRT"))
        INTO tag_emit;
      --------------------------
      -- <NFe><infNFe></emit> --
      --------------------------
      
      IF (v_cupomFiscal.cliente IS NOT NULL)
      THEN
        SELECT consumidor_final AS consFinal
          FROM public.pre_venda
          INTO v_consumidor_final
         WHERE id_cliente = v_cupomFiscal.cliente
           AND id_cupom_fiscal = p_idcupomfiscal;
      
        IF (v_consumidor_final IS NOT NULL)
        THEN
          consumidorFinal := v_consumidor_final.consFinal;
        END IF;
      END IF;
      
      IF (valorTotalLiquidoDosItens IS NOT NULL) AND (valorTotalLiquidoDosItens > 3000)
      THEN
          consumidorObrigatorio := true;
      END IF;

      -------------------------
      -- <NFe><infNFe><dest> --
      -------------------------
      IF (v_cupomFiscal.cliente IS NOT NULL) AND (consumidorFinal = false)
      THEN
        SELECT BTRIM(cliente.rua) AS xLgr
             , BTRIM(complemento) AS nro
             , BTRIM(bairro) AS xBairro
             , BTRIM(cod_ibge_municipio) AS cMun 
             , BTRIM(cidade) AS xMun
             , BTRIM(estado) AS UF
             , BTRIM(cep) AS CEP
             , BTRIM(cnpjcpf) AS CGC
             , BTRIM(nome) AS xNome
             , BTRIM(idc_inscr_estadual) AS indIEDest
             , BTRIM(inscricao_estadual) AS IE
             , BTRIM(inscricao_municipal) AS IM
             , BTRIM(email) AS email
             , utiliza_nfce AS incluirDadosNoXML
          INTO v_cliente
          FROM public.cliente
         WHERE id = v_cupomFiscal.cliente;
        ------------------------------------
        -- <NFe><infNFe><emit><enderDest> --
        ------------------------------------
        IF (consumidorObrigatorio = TRUE) OR ((v_cliente.incluirDadosNoXML IS NOT NULL) AND (v_cliente.incluirDadosNoXML = TRUE))
        THEN
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.xLgr AS "xLgr"));
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.nro AS "nro"));
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.xBairro AS "xBairro"));
            IF (v_cliente.cMun IS NULL OR v_cliente.cMun::INTEGER <= 0) THEN 
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(busca_cMun(v_cliente.xMun) AS "cMun"));
            ELSE 
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.cMun AS "cMun"));
            END IF;
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.xMun AS "xMun"));
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.UF AS "UF"));
            tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_cliente.CEP AS "CEP"));
              
            SELECT XMLELEMENT (name "enderDest" 
                  ,tag_enderDest)
              INTO tag_enderDest;  
            -------------------------------------
            -- <NFe><infNFe><emit></enderDest> --
            ------------------------------------- 
              
            length_CGC := LENGTH(v_cliente.CGC);
              
            IF (length_CGC = 11) 
            THEN 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.CGC AS "CPF"));
            ELSIF (length_CGC = 14) 
            THEN 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.CGC AS "CNPJ"));
            ELSE 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.CGC AS "idEstrangeiro"));
            END IF;
            
            IF (v_cliente.xNome IS NOT NULL) AND (v_cliente.xNome <> '')
            THEN
              if (v_cupomfiscal.tpAmb = '1')     
              then --[Produção]
                tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.xNome AS "xNome"));
              else --[Homologação]
                tag_dest := XMLConcat(tag_dest, XMLFOREST('NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL' AS "xNome"));
              end if;
            END IF;

            tag_dest := XMLCONCAT(tag_dest, tag_enderDest);
              
            tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.indIEDest AS "indIEDest"));
              
            IF (v_cliente.indIEDest = '1') 
            THEN
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.IE AS "IE"));
            END IF;
            
            IF (v_cliente.IM IS NOT NULL) AND (v_cliente.IM <> '') 
            THEN
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.IM AS "IM"));
            END IF;
              
            IF (v_cliente.email IS NOT NULL) AND (v_cliente.email <> '') 
            THEN
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_cliente.email AS "email"));
            END IF;
             
            SELECT XMLELEMENT(name "dest"
                 ,tag_dest)
              INTO tag_dest;
        END IF;
      ELSE
        ------------------------------------
        --     CLIENTE NÃO CADASTRADO     --
        ------------------------------------ 
        SELECT id_cupom AS id_cupom
             , BTRIM(nome) AS nome
             , BTRIM(cpf_cnpj) AS cpf_cnpj
             , BTRIM(logradouro) AS xLgr
             , numero AS nro
             , BTRIM(bairro) AS xBairro
             , codigo_municipio AS cMun
             , BTRIM(nome_municipio) AS xMun
             , BTRIM(sigla_uf) AS UF
             , BTRIM(cep) AS CEP
             , BTRIM(complemento) AS complemento
          INTO v_dados_cliente
          FROM public.dados_cliente
         WHERE id_cupom = p_idcupomfiscal;

        IF (v_dados_cliente.cpf_cnpj IS NOT NULL) AND (v_dados_cliente.cpf_cnpj <> '')
        THEN
          SELECT utiliza_nfce AS incluirDadosNoXML
            INTO v_cliente
            FROM public.cliente
           WHERE cnpjcpf = v_dados_cliente.cpf_cnpj;

          IF (consumidorObrigatorio = TRUE) OR ((v_cliente.incluirDadosNoXML IS NOT NULL) AND (v_cliente.incluirDadosNoXML = TRUE))
           OR (v_cliente.incluirDadosNoXML IS NULL)
          THEN
            ------------------------------------
            -- <NFe><infNFe><emit><enderDest> --
            ------------------------------------
            IF ((v_dados_cliente.xLgr IS NOT NULL) AND ((v_dados_cliente.nro IS NOT NULL) 
                 OR (v_dados_cliente.complemento IS NOT NULL)) AND (v_dados_cliente.xBairro IS NOT NULL)
                AND (v_dados_cliente.xMun IS NOT NULL) AND (v_dados_cliente.UF IS NOT NULL))
            THEN
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.xLgr AS "xLgr"));
              IF ((v_dados_cliente.nro IS NOT NULL) AND (v_dados_cliente.nro > 0))
              THEN
                tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.nro AS "nro"));
              ELSE
                tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.complemento AS "nro"));
              END IF;
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.xBairro AS "xBairro"));
               IF (v_dados_cliente.cMun IS NULL OR v_dados_cliente.cMun::INTEGER <= 0) THEN 
                tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(busca_cMun(v_dados_cliente.xMun) AS "cMun"));
              ELSE 
                tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.cMun AS "cMun"));
              END IF;
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.xMun AS "xMun"));
              tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.UF AS "UF"));
              IF (v_dados_cliente.CEP IS NOT NULL)
              THEN
                tag_enderDest := XMLCONCAT(tag_enderDest, XMLFOREST(v_dados_cliente.CEP AS "CEP"));
              END IF;
            END IF;

            IF (tag_enderDest IS NOT NULL)
            THEN
              SELECT XMLELEMENT (name "enderDest" 
                   , tag_enderDest)
                INTO tag_enderDest;
            END IF;
            -------------------------------------
            -- <NFe><infNFe><emit></enderDest> --
            ------------------------------------- 
              
            length_CGC := length(v_dados_cliente.cpf_cnpj);
              
            IF (length_CGC = 11) 
            THEN 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_dados_cliente.cpf_cnpj AS "CPF"));
            ELSIF (length_CGC = 14) 
            THEN 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_dados_cliente.cpf_cnpj AS "CNPJ"));
            ELSE 
              tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_dados_cliente.cpf_cnpj AS "idEstrangeiro"));
            END IF;
            
            IF (v_cupomfiscal.tpAmb = '2') --[Homologação]
            THEN
              tag_dest := XMLConcat(tag_dest, XMLFOREST('NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL' AS "xNome"));
            ELSE
              IF (v_dados_cliente.nome IS NOT NULL) AND (v_dados_cliente.nome <> '')  --[Produção]
              THEN
                tag_dest := XMLCONCAT(tag_dest, XMLFOREST(v_dados_cliente.nome AS "xNome"));
              ELSE
                tag_dest := XMLConcat(tag_dest, XMLFOREST('CONSUMIDOR FINAL' AS "xNome"));
              END IF;
            END IF;
            
            IF (tag_enderDest IS NOT NULL) 
            THEN
              tag_dest := XMLCONCAT(tag_dest, tag_enderDest);
            END IF;
            
            tag_dest := XMLCONCAT(tag_dest, XMLFOREST('9' AS "indIEDest"));
              
            SELECT XMLELEMENT(name "dest"
                 ,tag_dest)
              INTO tag_dest;
          END IF;
        END IF;
      END IF;
      --------------------------
      -- <NFe><infNFe></dest> --
      --------------------------
      IF (existeFrete) 
      THEN
        SELECT SUM(totalliquido) AS total
        FROM public.itemcupomfiscal
        INTO valorTotalLiquidoDosItens
        WHERE idcupomfiscal = p_idcupomfiscal
         AND cancelado = false;
         
        SELECT   mf.descricao        AS descricao
            ,mf.codigo_modalidade    AS codigoModalidade
            ,mf.permite_desconto_frete  AS permiteDescontoFrete
            ,mf.compoe_base_icms    AS compoeBaseIcms
            ,mf.compoe_base_pis_cofins   AS compoeBasePisCofins
        INTO v_dados_modalidade
        FROM public.modalidade_frete mf
        JOIN public.entrega ON entrega.id_modalidade_frete = mf.id
        WHERE entrega.id_cupom_fiscal = p_idcupomfiscal;  
        
        tratarDescontoNoFrete := v_dados_modalidade.permiteDescontoFrete;
        
        SELECT COALESCE(valor::BOOLEAN, FALSE) AS utilizar_empresa FROM public.configuracao
          INTO v_resultado
         WHERE chave = 'entrega.utilizar-empresa-como-transportadora';

        IF ((v_resultado IS NOT NULL) AND (v_resultado.utilizar_empresa)) THEN
             SELECT transp.cnpjceicpf AS CGC
                 ,transp.razaosocial xNome
                 ,transp.inscricaoestadual AS IE
                 ,transp.rua AS xEnder
                 ,transp.cidade AS xMun
                 ,transp.estado AS UF
             INTO v_transportadora
             FROM public.empresa transp
             JOIN public.entrega ON entrega.id_transportadora = transp.id
            WHERE entrega.id_cupom_fiscal = p_idcupomfiscal;
        ELSE 
             SELECT transp.cpf_cnpj AS CGC
                 ,transp.descricao AS xNome
                 ,transp.inscricao_estadual AS IE
                 ,transp.endereco AS xEnder
                 ,transp.cidade AS xMun
                 ,transp.uf AS UF
            INTO v_transportadora
            FROM public.transportadora transp
            JOIN public.entrega ON entrega.id_transportadora = transp.id
            WHERE entrega.id_cupom_fiscal = p_idcupomfiscal;
        END IF;
	  END IF;
      ------------------------
      -- <NFe><infNFe><det> --
      ------------------------
      SELECT indice AS indice
        INTO v_ultimo_item  
        FROM public.itemcupomfiscal
       WHERE idcupomfiscal = p_idcupomfiscal
         AND cancelado = false
       ORDER BY indice DESC
       LIMIT 1;

      FOR v_itemcupom IN 
        SELECT * 
          FROM public.itemcupomfiscal 
         WHERE idcupomfiscal = p_idCupomFiscal 
           AND cancelado = 'FALSE' 
         ORDER BY indice
      LOOP        
        SELECT   item.id          AS cProd
          ,BTRIM(ean.ean)        AS cEAN
          ,BTRIM(item.nome)      AS xProd
          ,rpad(BTRIM(item.ncm), 8, '0')    AS NCM
          ,item.codigo_cest      AS CEST  
          ,(CASE
            WHEN item.cst_icms IN ('10','30','60','70','90','500') AND item.industrializado = false THEN 5405
            WHEN item.cst_icms IN ('10','30','60','70','500') AND item.industrializado = true THEN 5401
            WHEN item.cst_icms IN ('00','20','40','41','50', '51', '90', '102', '103','300','400','900') AND item.industrializado = false THEN 5102
            WHEN item.cst_icms IN ('00','20','40','41','50','102','300','400') AND item.industrializado = true THEN 5101
            END)          AS CFOP
          ,BTRIM(uni.sigla)      AS uCom
          ,icf.quantidade        AS qCom
          ,icf.preco        AS vUnCom
          ,round(icf.totalbruto, 2)    AS vProd
          ,BTRIM(ean.ean)      AS cEANTrib
          ,BTRIM(uni.sigla)    AS uTrib
          ,icf.quantidade      AS qTrib
          ,round(icf.preco, 4) AS vUnTrib
          ,(CASE
            WHEN (existeFrete) THEN
            round(((((round(icf.totalliquido, 2) /  valorTotalLiquidoDosItens) * 100) * v_cupomFiscal.valorFrete) / 100), 2)
          END) AS vFrete  
          ,(CASE
            WHEN (tratarDescontoNoFrete) THEN
                round(icf.totaldesconto, 2) + round(((((trunc(icf.totalliquido, 2) /  valorTotalLiquidoDosItens) * 100) * v_cupomFiscal.valorFrete) / 100), 2)
            ELSE   round(icf.totaldesconto, 2)        
             END) AS vDesc
          ,round(icf.totaldesconto, 2) AS totalDesconto    
          ,lpad(BTRIM(item.cst_pis), 2, '0')    AS CST_PIS
          ,lpad(BTRIM(item.cst_cofins), 2, '0')  AS CST_COFINS
          ,BTRIM(item.cst_icms)      AS CST_ICMS
          ,BTRIM(item.origem_icms)    AS orig
                    ,item.percentual_fcp                    AS pFCP
                    ,item.aliquota_icms                     AS pICMS
          ,item.percentual_reducao    AS pRedBC  
          ,item.cod_motivo_icms_desonerado      AS codMotivoIcmsDesonerado
          ,item.aliquota_icms_desonerado        AS aliquotaIcmsDesonerado
          ,item.perc_diferimento_icms          AS percDiferimentoIcms
          ,item.base_icms_desonerado_imposto_embutido  AS baseIcmsDesoneradoImpostoEmbutido
          ,item.conceder_desconto_icms_desonerado    AS concederDescontoIcmsDesonerado
          ,BTRIM(item.cod_beneficio_fiscal)      AS codBeneficioFiscal
          ,item.codigo_anp              AS codigoAnp
          ,item.descricao_anp              AS descricaoAnp
                    
         INTO  v_det  
         FROM public.itemcupomfiscal icf
          ,item
          LEFT JOIN public.ean ON ean.iditem = item.id AND ean.desativado IS NULL
          ,unidade uni
        WHERE  item.unidade = uni.id
          AND  icf.iditem = item.id
          AND  icf.indice = v_itemcupom.indice
          AND   icf.idcupomfiscal = p_idCupomFiscal;
          
        /* Correção da diferença no somatório do valor do frete  */
        IF (existeFrete)
        THEN
          IF (quantidadeDeItensSuperiorAoRateio = false)
          THEN
            somatorioValorFrete := somatorioValorFrete + v_det.vFrete;
          END IF;
          
          IF (v_itemcupom.indice = v_ultimo_item.indice)
          THEN
            valorDiferencaFrete := 0;
            IF (somatorioValorFrete <> v_cupomFiscal.valorFrete)
            THEN
              somatorioValorFrete := somatorioValorFrete - v_det.vFrete;

              valorDiferencaFrete := v_cupomFiscal.valorFrete - somatorioValorFrete;
              v_det.vFrete := valorDiferencaFrete;

              somatorioValorFrete := v_cupomFiscal.valorFrete;
              IF (v_det.vDesc IS NOT NULL) AND (round(v_det.vDesc, 2) > 0) AND (tratarDescontoNoFrete) 
              THEN
                v_det.vDesc := v_det.vFrete + v_det.totalDesconto;
              END IF;
            END IF;
          END IF;
        END IF;

        IF (v_det.vFrete IS NOT NULL) AND (round(v_det.vFrete, 2) > 0)
        THEN
          efetuarRateioFrete := true;
        END IF;

        ------------------------------
        -- <NFe><infNFe><det><prod> --
        ------------------------------          
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.cProd AS "cProd"));

        IF (v_det.cEAN IS NULL)
        THEN
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST('SEM GTIN' AS "cEAN"));
        ELSE
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.cEAN AS "cEAN"));
        END IF;

        IF (v_cupomfiscal.tpAmb = '2') AND (v_itemcupom.indice = '1')     
        THEN --[Homologação]
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST('NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL' AS "xProd"));
        ELSE --[Produção]
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.xProd AS "xProd"));
        END IF;      
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.NCM AS "NCM"));
        
        IF (v_det.CEST IS NOT NULL) AND (LENGTH(v_det.CEST) > 0)
        THEN
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.CEST AS "CEST"));
        END IF;
        
        IF (v_det.codBeneficioFiscal IS NOT NULL) AND (v_det.codBeneficioFiscal <> '') AND (LENGTH(v_det.codBeneficioFiscal) > 0)
        THEN
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.codBeneficioFiscal AS "cBenef"));
        END IF;
        
        IF ((v_det.codigoAnp IS NOT NULL) AND (v_det.codigoAnp > 0))
        THEN
          --CFOP para produtos de combustíveis
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST('5656' AS "CFOP"));
        ELSE
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.CFOP AS "CFOP"));
        END IF;
        
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.uCom    AS "uCom"));
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.qCom    AS "qCom"));
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.vUnCom   AS "vUnCom"));
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.vProd AS "vProd"));  
        
        IF (v_det.cEANTrib IS NULL)
        THEN
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST('SEM GTIN' AS "cEANTrib"));
        ELSE
          tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.cEANTrib AS "cEANTrib"));
        END IF;
                
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.uTrib    AS "uTrib"));
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.qTrib    AS "qTrib"));
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.vUnTrib   AS "vUnTrib"));
        
        IF (existeFrete AND efetuarRateioFrete)
        THEN
          IF (quantidadeDeItensSuperiorAoRateio = false)
          THEN
            IF (somatorioValorFrete > v_cupomFiscal.valorFrete)
            THEN
              somatorioValorFrete := somatorioValorFrete - v_det.vFrete;

              valorDiferencaFrete := v_cupomFiscal.valorFrete - somatorioValorFrete ;
              v_det.vFrete := valorDiferencaFrete;
              IF (v_det.vDesc IS NOT NULL) AND (round(v_det.vDesc, 2) > 0) AND (tratarDescontoNoFrete) 
              THEN
                v_det.vDesc := v_det.vFrete + v_det.totalDesconto;
              END IF;
              quantidadeDeItensSuperiorAoRateio := true;
              somatorioValorFrete := v_cupomFiscal.valorFrete;
            END IF;
            IF (round(v_det.vFrete, 2) > 0)
            THEN
              tag_prod := XMLCONCAT(tag_prod, XMLFOREST(v_det.vFrete AS "vFrete"));
            END IF;
          ELSE
            v_det.vFrete := 0;
            efetuarRateioFrete := false;
          END IF;
        END IF;
          
        IF (v_det.vDesc IS NOT NULL) AND (round(v_det.vDesc, 2) > 0) 
        THEN          
            tag_prod := XMLCONCAT(tag_prod, XMLFOREST(round(v_det.vDesc, 2) AS "vDesc"));
            somatorioValorDesc := somatorioValorDesc + round(v_det.vDesc, 2);
        END IF;
          
        tag_prod := XMLCONCAT(tag_prod, XMLFOREST('1' AS "indTot"));
        
        --Tratamento para produtos de combustíveis
        IF ((v_det.codigoAnp IS NOT NULL) AND (v_det.codigoAnp > 0))
        THEN
          tag_combo := XMLCONCAT(tag_combo, XMLFOREST(v_det.codigoAnp AS "cProdANP"));
          tag_combo := XMLCONCAT(tag_combo, XMLFOREST(v_det.descricaoAnp AS "descANP"));
          tag_combo := XMLCONCAT(tag_combo, XMLFOREST('MG' AS "UFCons"));
          
          SELECT XMLELEMENT (name "comb"
                ,tag_combo)
            INTO tag_combo;  
          
          tag_prod := XMLCONCAT(tag_prod, tag_combo);
          tag_combo := NULL;
        END IF;
          
        SELECT XMLELEMENT (name "prod" 
              ,tag_prod)
          INTO tag_prod;  
        -------------------------------
        -- <NFe><infNFe><det></prod> --
        -------------------------------      
          
        ---------------------------------
        -- <NFe><infNFe><det><imposto> --
        ---------------------------------

          ---------------------------------------
          -- <NFe><infNFe><det><imposto><ICMS> --
          ---------------------------------------
          valorBcICMS := 0;
          valorICMS := 0;
          valorFCP := 0;
          valorBcFCP := 0;
          valorBcICMSDesonerado := 0;
          valorBcICMSDesonEmbutido := 0;

          /*--------------------------------------@
          |             LUCRO REAL                |
          @--------------------------------------*/
          IF (v_empresa.CRT IN ('2','3'))
          THEN
              -- Cálculos iguais para todos os CSTs, então ficaram de fora dos IFs, se tiver especificidade alterar internamente
            tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.orig AS "orig"));
            tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.CST_ICMS AS "CST"));
            
            existeFcp := (v_det.pFCP IS NOT NULL) AND (v_det.pFCP > 0);

            IF (v_det.CST_ICMS <> ('40')) AND (v_det.CST_ICMS <> ('41')) AND (v_det.CST_ICMS <> ('60'))
            THEN
              valorBcICMS := v_det.vProd;

              --Validação do desconto
              IF (v_det.vDesc IS NOT NULL) AND (v_det.vDesc > 0) 
              THEN
                valorBcICMS := valorBcICMS - round(v_det.vDesc, 2);
              END IF;
              
              --Validação da Redução da Base de Cálculo
              IF (v_det.pRedBC IS NOT NULL) AND (v_det.pRedBC > 0) 
              THEN
                IF (existeFrete AND efetuarRateioFrete)
                THEN
                  IF (v_det.CST_ICMS = '20') AND (v_dados_modalidade.compoeBaseIcms) 
                  THEN
                    valorBcICMS := (valorBcICMS + v_det.vFrete) * ((100 - v_det.pRedBC) / 100);
                  ELSE
                    valorBcICMS := valorBcICMS * ((100 - v_det.pRedBC) / 100);
                  END IF;
                ELSE
                  valorBcICMS := valorBcICMS * ((100 - v_det.pRedBC) / 100);
                END IF;
              END IF;
            END IF;

            IF (v_det.CST_ICMS = '00')
            THEN
              IF (existeFrete AND efetuarRateioFrete)
              THEN
                IF (v_dados_modalidade.compoeBaseIcms)
                THEN
                  valorICMS := (valorBcICMS + v_det.vFrete) * ((v_det.pICMS - v_det.pFCP)  / 100);
                  valorBcICMS := valorBcICMS + v_det.vFrete;
                ELSE
                  valorICMS := valorBcICMS * ((v_det.pICMS - v_det.pFCP)  / 100);
                END IF;
              ELSE
                valorICMS := valorBcICMS * ((v_det.pICMS - v_det.pFCP)  / 100);
              END IF;
              v_det.pICMS := v_det.pICMS - v_det.pFCP;
            
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('3' AS "modBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMS,2) AS "vBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pICMS AS "pICMS"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorICMS AS "vICMS"));
              
              -- Calcular aplicando os 2% da tag anterior pFCP na tag vBC
              valorFCP := valorBcICMS * (v_det.pFCP / 100);
              IF (existeFcp)
              THEN
                valorBcFCP := valorBcICMS;
                valorFCP := valorBcFCP * (round(v_det.pFCP, 2) / 100);
                -- vFCP = Calcular aplicando os 2% da tag anterior pFCP na tag vBCFCP.
                tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(v_det.pFCP,2) AS "pFCP"));
                tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorFCP AS "vFCP"));
              END IF;

              SELECT XMLELEMENT (name "ICMS00"
                        ,tag_tipo_ICMS)
              INTO tag_tipo_ICMS;

            ELSIF (v_det.CST_ICMS = '20')
            THEN
              valorBcICMSDesonerado := v_det.vProd;
              valorBcICMSDesonEmbutido := v_det.vProd;
            
              valorICMS := valorBcICMS * ((v_det.pICMS - v_det.pFCP)  / 100);
              v_det.pICMS := v_det.pICMS - v_det.pFCP;
            
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('3' AS "modBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pRedBC AS "pRedBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMS,2) AS "vBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(v_det.pICMS,2) AS "pICMS"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMS * (v_det.pICMS / 100),2) AS "vICMS"));
              
              IF (existeFcp)
              THEN
                valorBcFCP := valorBcICMS;
                valorFCP := valorBcFCP * (round(v_det.pFCP, 2) / 100);
                -- vBCFCP = Replicar o mesmo valor encontrado na TAG VBC.
                -- vFCP = Calcular aplicando os 2% da tag anterior pFCP na tag vBCFCP.
                tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcFCP,2) AS "vBCFCP"));
                tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(v_det.pFCP,2) AS "pFCP"));
                tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorFCP,2) AS "vFCP"));
              END IF;

              /* ICMS desonerado */
              IF (v_det.aliquotaIcmsDesonerado IS NOT NULL) AND (v_det.aliquotaIcmsDesonerado > 0) 
              THEN
                IF (v_det.baseIcmsDesoneradoImpostoEmbutido) 
                THEN
                  valorBcICMSDesonEmbutido := (valorBcICMSDesonEmbutido) / ((100 - v_det.aliquotaIcmsDesonerado) / 100);
                  valorBcICMSDesonEmbutido := (valorBcICMSDesonEmbutido * (v_det.pRedBC / 100)) * (v_det.aliquotaIcmsDesonerado / 100);
                  IF (round(valorBcICMSDesonEmbutido, 2) <= 0.00)
                  THEN
                    valorBcICMSDesonEmbutido := 0.01;
                  END IF;
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMSDesonEmbutido,2) AS "vICMSDeson"));
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.codMotivoIcmsDesonerado AS "motDesICMS"));

                  somatorioValorICMSDeson := somatorioValorICMSDeson + valorBcICMSDesonEmbutido;
                ELSE
                  valorBcICMSDesonerado := (valorBcICMSDesonerado * (v_det.pRedBC / 100)) * (v_det.aliquotaIcmsDesonerado / 100);
                  IF (round(valorBcICMSDesonerado, 2) <= 0.00)
                  THEN
                    valorBcICMSDesonerado := 0.01;
                  END IF;
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMSDesonerado,2) AS "vICMSDeson"));
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.codMotivoIcmsDesonerado AS "motDesICMS"));

                  somatorioValorICMSDeson := somatorioValorICMSDeson + valorBcICMSDesonerado;
                END IF;
              END IF;
              
              SELECT XMLELEMENT (name "ICMS20"
                        ,tag_tipo_ICMS)
              INTO tag_tipo_ICMS;

            ELSIF ((v_det.CST_ICMS = '40') OR (v_det.CST_ICMS = '41') OR (v_det.CST_ICMS = '50'))
            THEN
              valorBcICMSDesonerado := v_det.vProd;
              valorBcICMSDesonEmbutido := v_det.vProd;
              /* ICMS desonerado */
              IF (v_det.aliquotaIcmsDesonerado IS NOT NULL) AND (v_det.aliquotaIcmsDesonerado > 0)
              THEN
                IF (v_det.baseIcmsDesoneradoImpostoEmbutido) 
                THEN
                  valorBcICMSDesonEmbutido := (valorBcICMSDesonEmbutido) / ((100 - v_det.aliquotaIcmsDesonerado) / 100);
                  valorBcICMSDesonEmbutido := (valorBcICMSDesonEmbutido * (v_det.aliquotaIcmsDesonerado / 100));
                  IF (round(valorBcICMSDesonEmbutido, 2) <= 0.00)
                  THEN
                    valorBcICMSDesonEmbutido := 0.01;
                  END IF;
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMSDesonEmbutido,2) AS "vICMSDeson"));
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.codMotivoIcmsDesonerado AS "motDesICMS"));

                  somatorioValorICMSDeson := somatorioValorICMSDeson + valorBcICMSDesonEmbutido;
                ELSE
                  valorBcICMSDesonerado := (valorBcICMSDesonerado * (v_det.aliquotaIcmsDesonerado / 100));
                  IF (round(valorBcICMSDesonerado, 2) <= 0.00)
                  THEN
                    valorBcICMSDesonerado := 0.01;
                  END IF;
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMSDesonerado,2) AS "vICMSDeson"));
                  tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.codMotivoIcmsDesonerado AS "motDesICMS"));

                  somatorioValorICMSDeson := somatorioValorICMSDeson + valorBcICMSDesonerado;
                END IF;
              END IF;
            
              SELECT XMLELEMENT (name "ICMS40"
                        ,tag_tipo_ICMS)
              INTO tag_tipo_ICMS;

             ELSIF (v_det.CST_ICMS = '51')
             THEN
               SELECT XMLELEMENT (name "ICMS51"
                         ,tag_tipo_ICMS)
               INTO tag_tipo_ICMS;
             ELSIF (v_det.CST_ICMS = '60')
             THEN  
               SELECT XMLELEMENT (name "ICMS60"
                        ,tag_tipo_ICMS)
               INTO tag_tipo_ICMS;
             --Validar cálculos para o ICMS70, SOMENTE CRIADA A MÁSCARA para envio na SEFAZ.
             ELSIF (v_det.CST_ICMS = '70')
             THEN
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('3' AS "modBC"));
              --Não é necessário calcular a tag pRedBC para o ICMS.
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(0 AS "pRedBC"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMS,2) AS "vBC"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pICMS AS "pICMS"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorICMS AS "vICMS"));
               IF (existeFcp)
               THEN
                 valorBcFCP := valorBcICMS;
                 valorFCP := valorBcFCP * (round(v_det.pFCP, 2) / 100);
                 tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcFCP,2) AS "vBCFCP"));
                 tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pFCP AS "pFCP"));
                 tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorFCP AS "vFCP"));
               END IF;

              --Não calculados, apenas para completar as tags relacionadas ao ICMS70
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(0 AS "modBCST"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(0 AS "vBCST"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(0 AS "pICMSST"));
               tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(0 AS "vICMSST"));


               SELECT XMLELEMENT (name "ICMS70"
                         ,tag_tipo_ICMS)
               INTO tag_tipo_ICMS;
            ELSE 

              SELECT XMLELEMENT (name "ICMS90"
                        ,tag_tipo_ICMS)
              INTO tag_tipo_ICMS;
            END IF;
          ELSE 
            /*---------------------------------------------------------------
            |             Simples Nacional              |   
            @--------------------------------------------------------------*/
            tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.orig AS "orig"));
            
            /*
            Conforme anexo Nota Técnica 2015.002 - v 1.40 (atualizada em 23/03/2016), a regra 
            de validação N12a-20 diz que a CSOSN 900 será permitido a critério da UF e na 
            RG N12a-30 também diz que a regra será opcional a critério da UF. Portanto, 
            não serão utilizados os CSOSN 101, 103, 400 e 900.
            
            IF (v_det.CST_ICMS IN ('101'))
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('101' AS "CSOSN"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pICMS AS "pCredSN"));
              
              valorICMS := v_det.vProd * (v_det.pICMS / 100);
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorICMS AS "vCredICMSSN"));
              
              SELECT XMLELEMENT (name "ICMSSN101"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
                
            OBS.: Não será utilizado devido a nota técnica 2015.002 validação N12a-20. 
                  Consumidor final não utiliza.
            */
            IF (v_det.CST_ICMS = '102')
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.CST_ICMS AS "CSOSN"));
              
              SELECT XMLELEMENT (name "ICMSSN102"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            /*
            ELSIF (v_det.CST_ICMS = '103')
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.CST_ICMS AS "CSOSN"));
              
              SELECT XMLELEMENT (name "ICMSSN102"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            */
            /*
               A CSOSN 201,202 e 203 não serão utilizadas na operação interna.
            */
            ELSIF (v_det.CST_ICMS = '300')
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.CST_ICMS AS "CSOSN"));
              
              SELECT XMLELEMENT (name "ICMSSN102"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            /*
            ELSIF (v_det.CST_ICMS = '400')
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.CST_ICMS AS "CSOSN"));
              
              SELECT XMLELEMENT (name "ICMSSN102"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            */
            ELSIF (v_det.CST_ICMS = '500')
            THEN
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('500' AS "CSOSN"));
                
              SELECT XMLELEMENT (name "ICMSSN500"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            /*
            ELSIF (v_det.CST_ICMS = '900')
            THEN
              valorBcICMS := v_det.vProd;
              
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('900' AS "CSOSN"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST('3' AS "modBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(round(valorBcICMS,2) AS "vBC"));
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(v_det.pICMS AS "pICMS"));

              valorICMS := v_det.vProd * (v_det.pICMS / 100);
              tag_tipo_ICMS := XMLCONCAT(tag_tipo_ICMS, XMLFOREST(valorICMS AS "vICMS"));
              
              SELECT XMLELEMENT (name "ICMSSN900"
                    ,tag_tipo_ICMS)
                INTO tag_tipo_ICMS;
            */
            END IF;
          END IF;

          SELECT XMLELEMENT (name "ICMS"
                ,tag_tipo_ICMS)
          INTO tag_ICMS;
          
          tag_tipo_ICMS := NULL;
          
      
          
          somatorioValorBcICMS := somatorioValorBcICMS + valorBcICMS;
          somatorioValorICMS := somatorioValorICMS + valorICMS;
                    somatorioValorFCP := somatorioValorFCP + valorFCP;
          ----------------------------------------
          -- <NFe><infNFe><det><imposto></ICMS> --
          ----------------------------------------
        
          --------------------------------------
          -- <NFe><infNFe><det><imposto><PIS> --
          --------------------------------------
          valorPIS = 0;
          IF (v_empresa.CRT IN ('1','2'))
          THEN
             tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST('49' AS "CST"));
             tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST('0.00' AS "vBC"));
             tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST('0.00' AS "pPIS"));
             tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST('0.00' AS "vPIS"));

             SELECT XMLELEMENT (name "PISOutr"
                  , tag_tipo_PIS)
               INTO tag_tipo_PIS;

             SELECT XMLELEMENT (name "PIS"
                ,tag_tipo_PIS)
            INTO tag_PIS;
          ELSE
            IF (v_det.CST_PIS IS NOT NULL) AND (v_det.CST_PIS <> '')
            THEN
              tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST(v_det.CST_PIS AS "CST"));

              IF (v_empresa.CRT = '3' AND v_det.CST_PIS IN ('04','05','06','07','08','09'))
              THEN
                SELECT XMLELEMENT (name "PISNT"
                      ,tag_tipo_PIS)
                  INTO tag_tipo_PIS;

              ELSE
                IF (v_empresa.CRT = '3' AND v_det.CST_PIS IN ('03'))
                THEN
                  /*------------------------------------------------------------------------@
                  | No cenário atual de clientes, nenhum deles trabalha com este CST.       |
                  | Se existir, deverá ser implementado o cáculo no lugar deste comentário. |
                  @------------------------------------------------------------------------*/
                  SELECT XMLELEMENT (name "PISQtde"
                        ,tag_tipo_PIS)
                    INTO tag_tipo_PIS;
                ELSE
                  IF (existeFrete) AND (efetuarRateioFrete) AND (tratarDescontoNoFrete = FALSE)
                  THEN
                    IF (v_dados_modalidade.compoeBasePisCofins)
                    THEN
                      tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, 
                              XMLFOREST(round(v_itemcupom.totalliquido + v_det.vFrete,2) AS "vBC"));
                      valorPIS := (v_itemcupom.totalliquido + v_det.vFrete) * (v_empresa.pPIS/100);
                    ELSE
                      tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST(round(v_itemcupom.totalliquido,2) AS "vBC"));
                      valorPIS := v_itemcupom.totalliquido * (v_empresa.pPIS/100);
                    END IF;
                  ELSE
                    tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST(round(v_itemcupom.totalliquido,2) AS "vBC"));
                    valorPIS := v_itemcupom.totalliquido * (v_empresa.pPIS/100);
                  END IF;
                  tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST(v_empresa.pPIS AS "pPIS"));
                  tag_tipo_PIS := XMLCONCAT(tag_tipo_PIS, XMLFOREST(valorPIS AS "vPIS"));

                  IF (v_empresa.CRT = '3' AND v_det.CST_PIS IN ('01','02'))   
                  THEN
                    SELECT XMLELEMENT (name "PISAliq"
                          ,tag_tipo_PIS)
                      INTO tag_tipo_PIS;
                  --Regime do Simples Nacional
                  ELSE
                    SELECT XMLELEMENT (name "PISOutr"
                          ,tag_tipo_PIS)
                      INTO tag_tipo_PIS;
                  END IF;
                END IF;

              END IF;
            END IF;

            SELECT XMLELEMENT (name "PIS"
                 , tag_tipo_PIS)
              INTO tag_PIS;

          END IF;
          tag_tipo_PIS := NULL;
          somatorioValorPIS := somatorioValorPIS + valorPIS;
          ---------------------------------------
          -- <NFe><infNFe><det><imposto></PIS> --
          ---------------------------------------

          -----------------------------------------
          -- <NFe><infNFe><det><imposto><COFINS> --
          -----------------------------------------
          valorCOFINS = 0;
          IF (v_empresa.CRT IN ('1','2'))
          THEN
             tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST('49' AS "CST"));
             tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST('0.00' AS "vBC"));
             tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST('0.00' AS "pCOFINS"));
             tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST('0.00' AS "vCOFINS"));

            SELECT XMLELEMENT (name "COFINSOutr"
               , tag_tipo_COFINS)
            INTO tag_tipo_COFINS;

            SELECT XMLELEMENT (name "COFINS"
               , tag_tipo_COFINS)
            INTO tag_COFINS;
          ELSE
            IF (v_det.CST_COFINS IS NOT NULL) AND (v_det.CST_COFINS <> '')
            THEN
              tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(v_det.CST_COFINS AS "CST"));

              IF (v_empresa.CRT = '3' AND v_det.CST_COFINS IN ('04','05','06','07','08','09'))
              THEN
                SELECT XMLELEMENT (name "COFINSNT"
                     , tag_tipo_COFINS)
                  INTO tag_tipo_COFINS;
              ELSE
                IF (v_empresa.CRT = '3' AND v_det.CST_COFINS IN ('03'))
                THEN
                  /*------------------------------------------------------------------------@
                  | No cenário atual de clientes, nenhum deles trabalha com este CST.       |
                  | Se existir, deverá ser implementado o cáculo no lugar deste comentário. |
                  @------------------------------------------------------------------------*/
                  SELECT XMLELEMENT (name "COFINSQtde"
                        ,tag_tipo_COFINS)
                    INTO tag_tipo_COFINS;
                     
                ELSE
                  IF (existeFrete) AND (efetuarRateioFrete) AND (tratarDescontoNoFrete = FALSE)
                  THEN
                    IF (v_dados_modalidade.compoeBasePisCofins)
                    THEN
                      tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(round(v_itemcupom.totalliquido + v_det.vFrete,2) AS "vBC"));
                      valorCOFINS := (v_itemcupom.totalliquido + v_det.vFrete) * (v_empresa.pCOFINS/100);
                    ELSE
                      tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(round(v_itemcupom.totalliquido,2) AS "vBC"));
                      valorCOFINS := v_itemcupom.totalliquido * (v_empresa.pCOFINS/100);
                    END IF;
                  ELSE
                    tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(round(v_itemcupom.totalliquido,2) AS "vBC"));
                    valorCOFINS := v_itemcupom.totalliquido * (v_empresa.pCOFINS/100);
                  END IF;
                  tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(v_empresa.pCOFINS AS "pCOFINS"));
                  tag_tipo_COFINS := XMLCONCAT(tag_tipo_COFINS, XMLFOREST(valorCOFINS AS "vCOFINS"));

                  IF (v_empresa.CRT = '3' AND v_det.CST_COFINS IN ('01','02'))
                  THEN
                    SELECT XMLELEMENT (name "COFINSAliq"
                         , tag_tipo_COFINS)
                      INTO tag_tipo_COFINS;
                  -- Regime do Simples Nacional
                  ELSE
                    SELECT XMLELEMENT (name "COFINSOutr"
                         , tag_tipo_COFINS)
                      INTO tag_tipo_COFINS;
                  END IF;
                END IF;

              END IF;
            END IF;

            SELECT XMLELEMENT (name "COFINS"
                 , tag_tipo_COFINS)
              INTO tag_COFINS;

          END IF;
          tag_tipo_COFINS := NULL;
          somatorioValorCOFINS := somatorioValorCOFINS + valorCOFINS;
          ------------------------------------------
          -- <NFe><infNFe><det><imposto></COFINS> --
          ------------------------------------------
          
          -------------------------------------------
          -- <NFe><infNFe><det><imposto><vTotTrib> --
          -------------------------------------------
          valorTotalTributos := valorPIS + valorCOFINS + valorICMS;
          tag_total_tributos := valorTotalTributos;

          somatorioTotalTributos := somatorioTotalTributos + valorTotalTributos;
        
          SELECT XMLELEMENT (name "vTotTrib"
               , tag_total_tributos)
            INTO tag_total_tributos;

          SELECT XMLELEMENT (name "imposto"
               , tag_total_tributos
               , tag_ICMS
               , tag_PIS
               , tag_COFINS)
            INTO tag_imposto;
        ----------------------------------
        -- <NFe><infNFe><det></imposto> --
        ----------------------------------
        numeroDoItem := numeroDoItem + 1;

        SELECT XMLELEMENT (name "det"
             , XMLATTRIBUTES(numeroDoItem AS "nItem")
             , tag_prod
             , tag_imposto)
          INTO tag_det_tmp;

        tag_det := XMLCONCAT(tag_det, tag_det_tmp);
        tag_prod := NULL;
        tag_imposto:= NULL;

        somatorioValorItens := somatorioValorItens + v_det.vProd;
      END LOOP;
      -------------------------
      -- <NFe><infNFe></det> --
      -------------------------
              
      --------------------------
      -- <NFe><infNFe><total> --
      --------------------------  
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorBcICMS,0) AS "vBC"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorICMS,0) AS "vICMS"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorICMSDeson,0) AS "vICMSDeson"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorFCP,0) AS "vFCP"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vBCST"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vST"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vFCPST"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vFCPSTRet"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorItens,0) AS "vProd"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorFrete,0) AS "vFrete"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vSeg"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorDesc,0) AS "vDesc"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vII"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vIPI"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vIPIDevol"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorPIS,0) AS "vPIS"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioValorCOFINS,0) AS "vCOFINS"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(0 AS "vOutro"));

      /*------------------------------------------------------------------@
      | O valor líquido da NFC-e utiliza a seguinte fórmula:        |
      |-------------------------------------------------------------------|
      | vProd - vDesc + vST + vFrete + vSeg + vOutro + vII + vIPI + vServ  |      
      @------------------------------------------------------------------*/      
      valorLiquidoTotalNFCe := somatorioValorItens - somatorioValorDesc + somatorioValorFrete;
      
      /*IF (v_det.concederDescontoIcmsDesonerado) 
            THEN
        valorLiquidoTotalNFCe := valorLiquidoTotalNFCe - somatorioValorICMSDeson;
      END IF;*/
      
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(round(COALESCE(valorLiquidoTotalNFCe,0), 2) AS "vNF"));
      tag_ICMSTot := XMLCONCAT(tag_ICMSTot, XMLFOREST(COALESCE(somatorioTotalTributos,0) AS "vTotTrib"));
                   
      SELECT XMLELEMENT (name "ICMSTot"
            ,tag_ICMSTot)
        INTO tag_ICMSTot;

      SELECT XMLELEMENT (name "total"
            ,tag_ICMSTot)
        INTO tag_total;
      ---------------------------
      -- <NFe><infNFe></total> --
      ---------------------------
        
      --------------------------------
      -- <NFe><infNFe><pag><detPag> --
      --------------------------------
      FOR v_pag IN   SELECT   fp.forma_pagamento_sefaz AS tPag
            ,fpe.valor_recebido AS vPag
            ,(CASE
              WHEN fp.forma_pagamento_sefaz IN ('01','02','05') THEN NULL
              when ptef.rede = '00005' then '01425787000104'  --[REDE]
              when ptef.rede = '00018' then '71225700000122'  --[STANDBY]
              when ptef.rede = '00029' then '17351180000159'  --[SOFTWAY]
              when ptef.rede = '00043' then '03877288000175'  --[SENFF]
              when ptef.rede = '00051' then '03012230000169'  --[HIPERCARD]
              when ptef.rede = '00052' then '05045717000173'  --[TRICARD]
              when ptef.rede = '00054' then '00904951000195'  --[POLICARD]
              when ptef.rede = '00072' then '04627085000193'  --[BIGCARD]
              when ptef.rede = '00082' then '05127438000159'  --[GETNET]
              when ptef.rede = '00087' then '10673394000100'  --[MAXICRED]
              when ptef.rede = '00094' then '03766873000106'  --[CABAL]
              when ptef.rede = '00125' then '01027058000191'  --[CIELO]
              when ptef.rede = '00128' then '01498330000111'  --[COOPLIFE]
              when ptef.rede = '00166' then ''    --[UNIK]
              when ptef.rede = '00171' then '02561118000114'  --[VALESHOP]
              when ptef.rede = '00181' then '10440482000154'  --[GETNET LAC]
              when ptef.rede = '00207' then '12592831000189'  --[ELAVON]
              when ptef.rede = '00236' then '03645772000179'  --[CONDUCTOR]
              when ptef.rede = '00186' then '03817702000150'  --[BRASILCARD]
             END) AS CNPJ
            ,(CASE 
              WHEN fp.forma_pagamento_sefaz IN ('01','02','05') THEN NULL
              WHEN ptef.bandeira ='00001' THEN '01'   --[01: Visa]
              WHEN ptef.bandeira ='00002' THEN '02'  --[02: MasterCard]
              WHEN ptef.bandeira ='00004' THEN '03'  --[03: American Express]
              ELSE '99'        --[99: Outros]
             END) AS tBand
            ,tef.codigoautorizacao AS  cAut
            ,fp.cartao_pos AS cartao_pos
            FROM public.formapagamento fp
            ,formapagamentoefetuada fpe
            LEFT JOIN public.pagamentotef ptef ON ptef.idformapagamentoefetuada = fpe.id
            LEFT JOIN public.dadostefdedicado tef ON tef.idpagamentotef = ptef.id
           WHERE   fp.id = fpe.idforma
             AND   fpe.idcupom = p_idCupomFiscal
      LOOP
        tag_det_pag_tmp := XMLCONCAT(tag_det_pag_tmp, XMLFOREST(v_pag.tPag AS "tPag"));
        tag_det_pag_tmp := XMLCONCAT(tag_det_pag_tmp, XMLFOREST(round(v_pag.vPag,2) AS "vPag"));
          
        --------------------------------------
        -- <NFe><infNFe><pag><detPag><card> --
        --------------------------------------      
        /*------------------------------------------------------------@
        | Para alguns Cartões de Débito [04] será passado para a tag  |
        | tpIntegra valor 2 pois o SiTef não informa o tBand e cAut.  |
        @-------------------------------------------------------------*/
        IF (v_pag.tPag IN ('03', '04')) 
        THEN
          IF ((v_pag.CNPJ IS NOT NULL) AND (v_pag.CNPJ <> '') AND (v_pag.tBand IS NOT NULL) AND (v_pag.tBand <> '') AND (v_pag.cAut IS NOT NULL) AND (v_pag.cAut <> ''))
          THEN
            SELECT XMLELEMENT(name "card"
               ,XMLFOREST('1' AS "tpIntegra")
               ,XMLFOREST(v_pag.CNPJ   AS "CNPJ")
               ,XMLFOREST(v_pag.tBand AS "tBand")
               ,XMLFOREST(v_pag.cAut   AS "cAut"))
            INTO tag_card;
            
            tag_det_pag_tmp := XMLCONCAT(tag_det_pag_tmp, tag_card);
          ELSE
            SELECT XMLELEMENT(name "card"
               ,XMLFOREST('2' AS "tpIntegra"))
            INTO tag_card;

            tag_det_pag_tmp := XMLCONCAT(tag_det_pag_tmp, tag_card);
          END IF;
        ELSIF (v_pag.tPag IN ('99') AND v_pag.cartao_pos = TRUE)
        THEN
          SELECT XMLELEMENT(name "card"
               ,XMLFOREST('2' AS "tpIntegra")
               ,XMLFOREST(v_pag.CNPJ   AS "CNPJ")
               ,XMLFOREST(v_pag.tBand AS "tBand")
               ,XMLFOREST(v_pag.cAut   AS "cAut"))
            INTO tag_card;

          tag_det_pag_tmp := XMLCONCAT(tag_det_pag_tmp, tag_card);
        END IF;  
          
        ---------------------------------------
        -- <NFe><infNFe><pag><detPag></card> --
        ---------------------------------------
        SELECT XMLELEMENT (name "detPag"
              ,tag_det_pag_tmp)
          INTO tag_det_pag_tmp;
          
        tag_det_pag := XMLCONCAT(tag_det_pag, tag_det_pag_tmp);
        tag_det_pag_tmp := NULL;  
        
      END LOOP;
      
      IF (v_cupomFiscal.valorTroco IS NOT NULL) AND (v_cupomFiscal.valorTroco > 0)
      THEN
        tag_vTroco := XMLCONCAT(tag_vTroco, XMLFOREST(v_cupomFiscal.valorTroco AS "vTroco"));
        SELECT XMLELEMENT (name "pag"
            ,tag_det_pag
            ,tag_vTroco)
          INTO tag_pag;
        tag_vTroco := NULL;  
      ELSE
        SELECT XMLELEMENT (name "pag"
            ,tag_det_pag)
          INTO tag_pag;
      END IF;
      -------------------------
      -- <NFe><infNFe></pag> --
      -------------------------
    
      ----------------------------
      -- <NFe><infNFe><infAdic> --
      ----------------------------
      IF ((v_cupomFiscal.infCpl IS NOT NULL) AND (v_cupomFiscal.infCpl <> '' ) AND (LENGTH(v_cupomFiscal.infCpl) > 0))
      THEN
        informacoesAdicionais := v_cupomFiscal.infCpl;
        IF (somatorioValorICMSDeson > 0)
        THEN
          informacoesAdicionais := 'Valor total ICMS Desoneracao: ' || somatorioValorICMSDeson;
        END IF;
        
        SELECT XMLELEMENT (name "infAdic"
              ,XMLFOREST(BTRIM(informacoesAdicionais) AS "infCpl"))
           INTO tag_infAdic;
      ELSE
        IF (somatorioValorICMSDeson > 0)
        THEN
          informacoesAdicionais := 'Valor total ICMS Desoneracao: ' || somatorioValorICMSDeson;
          
          SELECT XMLELEMENT (name "infAdic"
              ,XMLFOREST(informacoesAdicionais AS "infCpl"))
           INTO tag_infAdic;
        END IF;
      END IF;
      
      IF (informacoesAdicionais IS NOT NULL) AND (informacoesAdicionais <> '')
      THEN
        UPDATE public.cupom_fiscal_eletronico 
         SET observacao = BTRIM(informacoesAdicionais)
        WHERE cupom_fiscal = p_idCupomFiscal;
      END IF;
      ----------------------------
      -- <NFe><infNFe></infAdic> --
      ----------------------------
      
    /*----------------------------------------------------------@
    | Modalidade do frete:                                      |
    | 0 – Contratação do Frete por conta do Remetente (CIF);    |
    | 1 – Contratação do Frete por conta do Destinatário (FOB); |
    | 2 – Contratação do Frete por conta de Terceiros;          |
    | 3 – Transporte Próprio por conta do Remetente;            |
    | 4 – Transporte Próprio por conta do Destinatário;         |
    | 9 – Sem Ocorrência de Transporte                          |
    @----------------------------------------------------------*/

    modalidadeFrete := 9;
    IF (existeFrete)
    THEN
      modalidadeFrete := v_dados_modalidade.codigoModalidade;
      tag_transp := XMLCONCAT(tag_transp, XMLFOREST(modalidadeFrete AS "modFrete"));
      IF (v_transportadora.CGC IS NOT NULL) 
      THEN
        IF (LENGTH(v_transportadora.CGC) = 11) 
        THEN 
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.CGC     AS "CPF"));
        ELSE  
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.CGC     AS "CNPJ"));
        END IF;
        IF (v_transportadora.xNome IS NOT NULL) 
        THEN
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.xNome  AS "xNome"));
        END IF;
        IF (v_transportadora.IE IS NOT NULL) 
        THEN
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.IE     AS "IE"));
        END IF;
        IF (v_transportadora.xEnder IS NOT NULL) 
        THEN
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.xEnder   AS "xEnder")); 
        END IF;
        IF (v_transportadora.xMun IS NOT NULL) 
        THEN
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.xMun   AS "xMun"));
        END IF;
        IF (v_transportadora.UF IS NOT NULL) 
        THEN
          tag_transporta := XMLCONCAT(tag_transporta, XMLFOREST(v_transportadora.UF     AS "UF"));
        END IF;
        
        SELECT XMLELEMENT(name "transporta"
             ,tag_transporta)
          INTO tag_transporta;
      END IF;
      
      tag_transp := XMLCONCAT(tag_transp, tag_transporta);
      
      SELECT XMLELEMENT(name "transp"
           ,tag_transp)
        INTO tag_transp;
    ELSE
      tag_transp := XMLELEMENT(name "transp", XMLFOREST(modalidadeFrete AS "modFrete"));
    END IF;  

    
    SELECT XMLELEMENT(name "infNFe"
         ,XMLATTRIBUTES('NFe' || chaveNFCe AS "Id", '4.00' AS "versao")
         ,tag_ide
         ,tag_emit
         ,tag_dest
         ,tag_det
         ,tag_total
         ,tag_transp
         ,tag_pag
         ,tag_infAdic)
      INTO tag_infNFe;
    --------------------
    -- <NFe></infNFe> --
    --------------------

  qrCode := '<![CDATA[' || v_cupomFiscal.qrCode || ']]>';
  IF (qrCode IS NOT NULL)
  THEN
    IF (v_cupomfiscal.tpAmb = '2')     
    THEN --[Homologação]
      urlChave := 'http://hnfce.fazenda.mg.gov.br/portalnfce';
    ELSE
      urlChave := 'http://nfce.fazenda.mg.gov.br/portalnfce';
    END IF;
  
    SELECT XMLELEMENT(name "infNFeSupl"
         ,XMLFOREST(XMLPARSE(CONTENT qrCode) AS "qrCode")
         ,XMLFOREST(urlChave AS "urlChave"))
      INTO tag_infNFeSupl;
  END IF;
  
  SELECT XMLELEMENT(name "NFe"

       ,XMLATTRIBUTES('http://www.portalfiscal.inf.br/nfe' AS "xmlns")
       ,tag_infNFe
       ,tag_infNFeSupl
       ,tag_Signature)
    INTO tag_NFe;

  SELECT XMLELEMENT(NAME "enviNFe"
       ,XMLATTRIBUTES('4.00' AS "versao", 'http://www.portalfiscal.inf.br/nfe' AS "xmlns")
       ,XMLFOREST(v_cupomFiscal.cNF AS "idLote")
       ,XMLFOREST(1 AS "indSinc")
       ,tag_NFe)
    INTO tag_enviNFe;

  --tag_enviNFe := xmlroot(tag_enviNFe, version '1.0', standalone yes);  
  ------------
  -- <NFe/> --
  ------------

  /*------------------------------------------------------------------------------@
  | Atualizando a tabela de cupons fiscais eletrônicos inserindo informações que, |
  | normalmente, são muito utilizadas. Isto evita que a aplicação tenha que ler o |
  | XML inteiro para pegar estas informações.                    |
  @------------------------------------------------------------------------------*/
  UPDATE public.cupom_fiscal_eletronico 
     SET  chave_eletronica = chaveNFCe,
    versao_xml = '4.00',
    total_icms = somatorioValorICMS,
    total_tributos = somatorioValorPIS + somatorioValorCOFINS + somatorioValorICMS
   WHERE   cupom_fiscal = p_idCupomFiscal;

  RETURN tag_enviNFe;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
