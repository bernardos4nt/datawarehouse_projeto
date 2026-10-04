/*Esse código cria as tabelas e suas colunas quando executadas inteiramente */





--Criando tabela das informações dos clientes
IF OBJECT ID ('Bronze.crm_cust_info' , 'U') IS NOT NULL
	DROP Bronze.crm_cust_info
CREATE TABLE Bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

--Criando tabela das informações dos produtos
IF OBJECT ID ('Bronze.crm_prd_info' , 'U') IS NOT NULL
	DROP Bronze.crm_prd_info
CREATE TABLE Bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost FLOAT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

--Criando tabela dos detalhes das vendas
IF OBJECT ID ('Bronze.crm_sales_details' , 'U') IS NOT NULL
	DROP Bronze.crm_sales_details
CREATE TABLE Bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	ss_price INT
);

--Tabela dos clientes
IF OBJECT ID ('Bronze.erp_CUST' , 'U') IS NOT NULL
	DROP Bronze.erp_CUST
CREATE TABLE Bronze.erp_CUST(
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50),
);

--Tabela dos países dos clientes
IF OBJECT ID ('Bronze.erp_LOC' , 'U') IS NOT NULL
	DROP Bronze.erp_LOC
CREATE TABLE Bronze.erp_LOC(
	CID NVARCHAR(50),
	COUNTRY NVARCHAR(50)
);

--Tabela das especificações dos produtos
IF OBJECT ID ('Bronze.erp_PX_CAT' , 'U') IS NOT NULL
	DROP Bronze.erp_PX_CAT
CREATE TABLE Bronze.erp_PX_CAT(
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTANANCE NVARCHAR(50)
);
