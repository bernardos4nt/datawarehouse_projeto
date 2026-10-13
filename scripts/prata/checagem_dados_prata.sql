/*
Query voltada para a verificação de inconsistências ilógicas e estéticas nos dados importados da camada bronze,
o esperado é que as tabelas geradas por esses códigos sejam vazias
*/

--Checar dados repetidos ou nulos
SELECT
(Categoria que gostaria de verificar),
COUNT(*) FROM Prata.crm_cust_info GROUP BY (Categoria que gostaria de verificar)
HAVING COUNT(*) > 1 OR (Categoria que gostaria de verificar) IS NULL;
    

--Checar espaços indesejados
SELECT
(Coluna que gostaria de verificar),
FROM Prata.crm_cust_info
WHERE (Coluna que gostaria de verificar) != TRIM((Coluna que gostaria de verificar));


--Classificação de colunas
SELECT DISTINCT
(Coluna que gostaria de verificar),
FROM Prata.crm_cust_info;



--Checar a existência de números nulos ou negativos
SELECT
(Coluna que gostaria de verificar),
COUNT(*)
FROM Prata.crm_prd_info
GROUP BY (Coluna que gostaria de verificar)
HAVING COUNT(*) > 1 OR (Coluna que gostaria de verificar) IS NULL;


--Checando datas inconsistentes
SELECT*FROM Prata.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


--Checando datas inválidas e inlógicas
SELECT
NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

SELECT * FROM Prata.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

--Checando valores nulos ou fora de intervalos razoáveis (quando é necessário comparar com outros dados)
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM Prata.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


--Checando nascimentos impossíveis
SELECT DISTINCT
    bdate
FROM Prata.erp_CUST
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();
