CREATE OR REPLACE VIEW public.vw_conferencia_caixa (
  DFid_sessao
, DFdt_abertura
, DFdt_fechamento
, DFsessao_fechada
, DFqtde_sangria
, DFtotal_sangria
, DFqtde_suprimento
, DFtotal_suprimento
, DFvalor_informado
, DFvalor_apurado
, DFdiferenca) AS
SELECT 
  ss.id AS DFid_sessao
, MAX(ss.abertura) AS DFdt_abertura  
, MAX(ss.fechamento) AS DFdt_fechamento
, (ss.fechamento IS NOT NULL AND ss.fechado) AS DFsessao_fechada
, COUNT(se.id) AS DFqtde_sangria
, COALESCE(SUM(se.valor), 0.00)::numeric(18,4) AS DFtotal_sangria
, COUNT(sp.id) AS DFqtde_suprimento
, COALESCE(SUM(sp.valor))::numeric(18,4) AS DFqtde_suprimento
, MAX(cc.valor_informado)::numeric(18,4) AS DFvalor_informado
, MAX(cc.valor_apurado)::numeric(18,4) AS DFvalor_apurado
, MAX(cc.diferenca)::numeric(18,4) AS DFdiferenca
FROM sessao ss
LEFT JOIN conferencia_caixa cc on cc.id_sessao = ss.id
LEFT JOIN sangriaefetuada se ON se.idsessao = ss.id 
LEFT JOIN suprimento sp ON sp.idsessao = ss.id
GROUP BY ss.id
ORDER BY ss.id DESC;