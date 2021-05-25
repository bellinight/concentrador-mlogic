ALTER TABLE relatorio_desconto
 DROP CONSTRAINT IF EXISTS fk_relatorio_desconto_cupom_fiscal,
  ADD CONSTRAINT fk_relatorio_desconto_cupom_fiscal FOREIGN KEY (id_cupom_fiscal) REFERENCES cupomfiscal(id) ON UPDATE CASCADE ON DELETE CASCADE;