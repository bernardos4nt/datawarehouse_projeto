/* Esse código carrega os dados nas tabelas criadas na query "criação_tabelas_bronze.sql"
  -Já está formatada
  -Timeout de 6 segundos
  -Em caso de alteração, não rodar o EXEC sem executar o resto na query
*/
  

CREATE or ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME
	BEGIN TRY
		PRINT '============================'
		PRINT 'Carregando camada bronze'
		PRINT '============================'

		PRINT '----------------------------'
		PRINT 'Carregando tabelas CRM'
		PRINT '----------------------------'

		--Inserção de dados na tabela informações dos clientes
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';
		



		--Inserção de dados na tabela informações do produto
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';

		--Inserção de dados dos detalhes das vendas
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details
		
		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';

		

		PRINT '----------------------------'
		PRINT 'Carregando tabelas ERP'
		PRINT '----------------------------'


		--Inserção de dados na tabela sobre clientes
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.erp_CUST'
		TRUNCATE TABLE bronze.erp_CUST

		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.erp_CUST
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';

		

		--Inserção de dados na tabela sobre países dos clientes
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.erp_LOC'
		TRUNCATE TABLE bronze.erp_LOC

		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.erp_LOC
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';
		


		--Inserção de dados na tabela sobre detalhes dos produtos
		SET @start_time = GETDATE();
		PRINT '-->Truncando Tabela: bronze.erp_PX_CAT'
		TRUNCATE TABLE bronze.erp_PX_CAT

		PRINT '-->Inserindo dados na tabela'
		BULK INSERT bronze.erp_PX_CAT
		FROM 'C:\Users\santi\Downloads\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK	
		);
		SET @end_time = GETDATE();
		PRINT '--> Tempo de carregamento:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'segundos';
		PRINT '--------------------------------------';


	END TRY
	BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS numero_erro,
        ERROR_LINE() AS linha_erro,
        ERROR_MESSAGE() AS mensagem_erro;

    THROW;
END CATCH;
END

SET LOCK_TIMEOUT 6000;
EXEC bronze.load_bronze --Não rode essa linha caso tenha alterado algo na query sem antes rodar o resto
EXEC bronze.load_bronze
