--[Heuristica para tentar evitar ajustes manuais para a NFC-e]--
UPDATE cliente
   SET cod_ibge_municipio = empresa.codigoibge
  FROM empresa  
 WHERE cliente.estado = empresa.estado AND cliente.cidade = empresa.cidade;