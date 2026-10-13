/*
Esse código integra os dados das tabelas envolvendo especificamente a Prata.crm_fact_sales
*/

CREATE VIEW Ouro.fact_vendas AS
SELECT
	sl.sls_ord_num AS ID_pedido,
	pd.ID_categoria as ID_categoria,
	cu.Chave_cliente as Chave_cliente,
	sl.sls_prd_key as ID_produto,
	sl.sls_cust_id as ID_venda,
	sl.sls_order_dt AS Data_pedido,
	sl.sls_ship_dt AS Data_exportação,
	sl.sls_due_dt AS Data_prazo,
	sl.sls_price AS Preço_venda,
	sl.sls_quantity AS Qtd_venda
	FROM Prata.crm_sales_details sl
	
	LEFT JOIN Ouro.dim_produtos pd ON sl.sls_prd_key = pd.ID_categoria
	LEFT JOIN Ouro.dim_clientes cu ON sl.sls_cust_id = cu.Chave_cliente
