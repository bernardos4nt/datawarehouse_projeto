/*
Esse código integra os dados das tabelas envolvendo especificamente a Prata.crm_prd_info
*/

CREATE VIEW Ouro.dim_produtos AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt) AS Inicio_data, --Ordenação específica
	pr.prd_id AS ID_produto,
	pr.cat_id as ID_categoria,
	pr.prd_key as Chave_produto,
	pr.prd_nm as Nome_produto,
	pr.prd_line as Linha_produto,
	pc.CAT as Categoria,
	pc.SUBCAT as Subcategoria,
	pc.MAINTENANCE as Manutenção,
	pr.prd_cost as Custo_produto,
	pr.prd_start_dt as Inicio
	FROM Prata.crm_prd_info pr
	
	LEFT JOIN Prata.erp_PX_CAT pc ON pr.cat_id = pc.ID
	WHERE prd_end_dt IS NULL --Para remover os já finalizados
