DO $$
<<atualiza_id_cupom_e_id_item_relatorio_desconto>>
DECLARE
  rd_ccf INTEGER := 0;
  rd_serieecf varchar(10) := '0';
  rd_descricao varchar(50) := '';
  status varchar(10) := 'ATUALIZADO';
  cupom_id INTEGER := 0;
  item_id INTEGER := 0;
  rd_id INTEGER := 0;
BEGIN
  FOR rd_id
    , rd_ccf
    , rd_serieecf
    , rd_descricao
  IN SELECT id
          , ccf
          , (SUBSTRING(serieecf, 0, 5) || LPAD(SUBSTRING(serieecf, 5), 3,'0')) AS serieecf
          , descricao
       FROM relatorio_desconto 
      WHERE (id_cupom_fiscal IS null) OR (id_item IS null)
      ORDER BY 1
       LOOP
         SELECT c.id, icf.iditem AS item_id FROM cupomfiscal c
           INTO cupom_id, item_id
           LEFT JOIN itemcupomfiscal icf ON (icf.idcupomfiscal = c.id) 
          WHERE ccf = rd_ccf 
            AND (SUBSTRING(serieecf, 0, 5) || LPAD(SUBSTRING(serieecf, 5), 3,'0')) ILIKE rd_serieecf;

         IF ((cupom_id IS null)) THEN
           DELETE FROM relatorio_desconto where id = rd_id;
           status := 'DELETADO'; 
         ELSE
           IF item_id IS null THEN
             SELECT id INTO item_id FROM item where descricao ILIKE rd_descricao LIMIT 1;
           END IF;

           UPDATE relatorio_desconto
              SET id_cupom_fiscal = cupom_id, id_item = item_id
            WHERE id = rd_id;

           status := 'ATUALIZADO';
         END IF;

         RAISE NOTICE 'STATUS: %, REL_DESC_ID: %, SERIE_RD: %, CCF_RD: %, ITEM_ID: %, CUPOM_ID: %'
                     , status, rd_id, rd_serieecf, rd_ccf, item_id, cupom_id;
       END LOOP;
END atualiza_id_cupom_e_id_item_relatorio_desconto $$;