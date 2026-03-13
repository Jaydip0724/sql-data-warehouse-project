-- Create Database 'DataWarehouse'
USE master;
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

/*
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

*/
-- CRM TAbles



/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
    Creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	DDL structure of 'bronze' Tables
===============================================================================
*/
--- CRM Tables -------------------------------------------
IF OBJECT_ID('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info

CREATE TABLE bronze.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

CREATE  TABLE bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL 
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);


-- ERP TABLES --------------------------------------------------

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12(
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50)
);


IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101(
cid NVARCHAR(50),
cntry NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
);

-- ---------------------------------------------------------
       -- BULK INSERT
-- ---------------------------------------------------------
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN 
	DECLARE @batch_start_time DATETIME;
	DECLARE @batch_end_time DATETIME;
	DECLARE @start_time DATETIME; 
	DECLARE @end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '********************************************************';
		PRINT '               Loading Data Tables                      '
		PRINT '********************************************************';
		PRINT ' ---------- Loading CRM Tables --------------------------';

		-- CRM TABLE BULK INsert -------------------
		SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting data into table : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info 
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
				);
		SET @end_time = GETDATE();
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting data into : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
				);

		SET @end_time = GETDATE();
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';

		
		SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.crm_sales_details ';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting data into table : bronze.crm_sales_details ';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR =',',
				TABLOCK
				);
		SET @end_time = GETDATE();
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';



		-- --ERP TAble BULK INSERT -------------------------------
		PRINT ' ---------- Loading ERP Tables --------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting data into table : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE();
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';


	    SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting data into table : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);

		SET @end_time = GETDATE()
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating table : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting data into table : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\CDac_Banglore\SQL_Poject\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR = ',',
			TABLOCK
			);
		SET @end_time = GETDATE()
		PRINT ' Load Duration : '+ CAST(DATEDIFF(second,@start_time, @end_time) AS NVARCHAR(50))+' seconds';

		SET @batch_end_time = GETDATE();
		PRINT ' BATCH Load Duration : '+ CAST(DATEDIFF(second,@batch_start_time, @batch_end_time) AS NVARCHAR(50))+' seconds';

	END TRY
	BEGIN CATCH
		PRINT '=======================================================';
		PRINT '         ERROR OCCURED DURING BRONZE LAYER             '
		PRINT '=======================================================';
		PRINT 'ERROR Message '+ ERROR_MESSAGE();
		PRINT 'ERROR Message '+ CAST (ERROR_NUMBER() AS NVARCHAR(50));
		PRINT 'ERROR State'+ CAST(ERROR_STATE() AS NVARCHAR(50));
		PRINT '=======================================================';
	END CATCH

END;

EXEC bronze.load_bronze;