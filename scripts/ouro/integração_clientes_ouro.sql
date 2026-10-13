/*
Esse código integra os dados entre tabelas envolvendo a tabela Prata.crm_cust_info
*/




CREATE VIEW Ouro.dim_clientes AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS Chave, --(Caso queira uma ordenação específica, altere o aspecto)
	ci.cst_key AS Chave_cliente,
	ci.cst_firstname as Nome,
	ci.cst_lastname as Sobrenome,
	la.COUNTRY as País_origem,
	cst_marital_status as Estado_civil,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
		END AS gênero,
	ca.BDATE as data_nascimento,
	ci.cst_create_date as Create_date

	FROM Prata.crm_cust_info ci

	LEFT JOIN Prata.erp_CUST ca
	ON ci.cst_key = ca.CID
	LEFT JOIN Prata.erp_LOC la
	ON ci.cst_key = la.CID
