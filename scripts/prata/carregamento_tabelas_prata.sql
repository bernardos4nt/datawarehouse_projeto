/*
Essa query coloca os dados das tabelas criadas da camada prata
  -Rode somente da linha 10 em diante para exibir a mensagem estruturada
  -Rode a primeira linha somente se alterar algum aspecto da camada Prata
*/





CREATE OR ALTER PROCEDURE Prata.load_Prata AS --Rode essa linha somente se alterar algo no esquema

  
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Carregando camada prata';
        PRINT '================================================';
		
		PRINT 'Carregando Tabelas CRM';
		
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela';
		TRUNCATE TABLE Prata.crm_cust_info;
		PRINT '>> Inserindo dados na tabela: Prata.crm_cust_info';
		INSERT INTO Prata.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Solteiro/a'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Casado/a'
				ELSE 'n/a'
			END AS cst_marital_status, 
			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Feminino'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Masculino'
				ELSE 'n/a'
			END AS cst_gndr, 
			cst_create_date
		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE flag_last = 1; 
		SET @end_time = GETDATE();
        PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        
		
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: Prata.crm_prd_info';
		TRUNCATE TABLE Prata.crm_prd_info;
		PRINT '>> Colocando dados em: Prata.crm_prd_info';
		INSERT INTO Prata.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, 
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line, 
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1
				AS DATE
			) AS prd_end_dt 
		FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        
        
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: Prata.crm_sales_details';
		TRUNCATE TABLE Prata.crm_sales_details;
		PRINT '>> Colocando dados em: Prata.crm_sales_details';
		INSERT INTO Prata.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales, 
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price  
			END AS sls_price
		FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
       
        
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: Prata.erp_CUST';
		TRUNCATE TABLE Prata.erp_CUST;
		PRINT '>> Colocando dados em: Prata.erp_CUST';
		INSERT INTO Prata.erp_CUST (
			cid,
			bdate,
			gen
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
				ELSE cid
			END AS cid,
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate, 
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen 
		FROM bronze.erp_CUST;
	    SET @end_time = GETDATE();
        PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
       
		PRINT 'Carregando tabelas ERP';
		
        
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: Prata.erp_LOC';
		TRUNCATE TABLE Prata.erp_LOC;
		PRINT '>> Colocando dados em: Prata.erp_LOC';
		INSERT INTO Prata.erp_LOC (
			cid,
			COUNTRY
		)
		SELECT
			REPLACE(cid, '-', '') AS cid,
			CASE
				WHEN TRIM(COUNTRY) = 'DE' THEN 'Germany'
				WHEN TRIM(COUNTRY) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(COUNTRY) = '' OR COUNTRY IS NULL THEN 'n/a'
				ELSE TRIM(COUNTRY)
			END AS COUNTRY 
		FROM bronze.erp_LOC;
	    SET @end_time = GETDATE();
        PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        

		SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: Prata.erp_PX_CAT';
		TRUNCATE TABLE Prata.erp_PX_CAT;
		PRINT '>> Colocando dados em: Prata.erp_PX_CAT';
		INSERT INTO Prata.erp_PX_CAT (
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		SELECT
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE

		FROM bronze.erp_PX_CAT;
		SET @end_time = GETDATE();
		PRINT '>> Tempo de carregamento: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Carregamento da camada prata completo';
        PRINT '   - Total duração carregamento: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERRO OCORREU NO CARREGAMENTO DA CAMADA PRATA'
		PRINT 'Mensagem de erro' + ERROR_MESSAGE();
		PRINT 'Mensagem de erro' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Mensagem de erro' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
