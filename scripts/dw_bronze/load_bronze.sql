/*
===============================================================================
Bronze Layer: Bulk Data Loading 
===============================================================================
Usage:
	- execute this script for data loading into bronze layer
Purpose:
	- MySQL server doesn't support stored procedure for bulk loading data, so we made a raw script file with hard coded file names
    - we expect the files are always present in the local storage with the same names
    - additionally we can use Python workaround for EL part of the ETL process
Pattern Applied:
1. Capture all columns into @variables first.
2. Use SET ... = NULLIF(@var, '') to convert empty CSV fields into real SQL NULLs.
3. Handle Date parsing if necessary.
4. Adds logging with print statements 
===============================================================================
*/

use dw_bronze;
SELECT '===============================================================================';
SELECT '🚀 Loading Bronze Layer';
SELECT '===============================================================================';


-- ====================================================
-- 1. CRM Customer Info
-- ====================================================
SELECT '>> Loading: crm_cust_info';
TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @cst_id, @cst_key, @cst_firstname, @cst_lastname, 
    @cst_marital_status, @cst_gender, @cst_create_date
)
SET 
    cst_id             = NULLIF(@cst_id, ''),
    cst_key            = NULLIF(@cst_key, ''),
    cst_firstname      = NULLIF(@cst_firstname, ''),
    cst_lastname       = NULLIF(@cst_lastname, ''),
    cst_marital_status = NULLIF(@cst_marital_status, ''),
    cst_gender         = NULLIF(@cst_gender, ''),
    cst_create_date    = NULLIF(@cst_create_date, '');

-- ====================================================
-- 2. CRM Product Info
-- ====================================================
TRUNCATE TABLE crm_prd_info;
SELECT '>> Loading: crm_prd_info';
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @prd_id, @prd_key, @prd_nm, @prd_cost, 
    @prd_line, @prd_start_dt, @prd_end_dt
)
SET 
    prd_id       = NULLIF(@prd_id, ''),
    prd_key      = NULLIF(@prd_key, ''),
    prd_nm       = NULLIF(@prd_nm, ''),
    prd_cost     = NULLIF(@prd_cost, ''),
    prd_line     = NULLIF(@prd_line, ''),
    prd_start_dt = NULLIF(@prd_start_dt, ''),
    prd_end_dt   = NULLIF(@prd_end_dt, '');

-- ====================================================
-- 3. CRM Sales Details
-- ====================================================
TRUNCATE TABLE crm_sales_details;
SELECT '>> Loading: crm_sales_details';
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, 
    @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price
)
SET 
    sls_ord_num  = NULLIF(@sls_ord_num, ''),
    sls_prd_key  = NULLIF(@sls_prd_key, ''),
    sls_cust_id  = NULLIF(@sls_cust_id, ''),
    sls_order_dt = NULLIF(@sls_order_dt, ''),
    sls_ship_dt  = NULLIF(@sls_ship_dt, ''),
    sls_due_dt   = NULLIF(@sls_due_dt, ''),
    sls_sales    = NULLIF(@sls_sales, ''),
    sls_quantity = NULLIF(@sls_quantity, ''),
    sls_price    = NULLIF(@sls_price, '');

-- ====================================================
-- 4. ERP Customer (Legacy System)
-- ====================================================
TRUNCATE TABLE erp_cust_az12;
SELECT '>> Loading: erp_cust_az12';
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @cid, @bdate, @gen
)
SET 
    cid   = NULLIF(@cid, ''),
    bdate = NULLIF(@bdate, ''),
    gen   = NULLIF(@gen, '');

-- ====================================================
-- 5. ERP Location
-- ====================================================
TRUNCATE TABLE erp_loc_a101;
SELECT '>> Loading: erp_loc_a101';
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @cid, @cntry
)
SET 
    cid   = NULLIF(@cid, ''),
    cntry = NULLIF(@cntry, '');

-- ====================================================
-- 6. ERP Product Category
-- ====================================================
TRUNCATE TABLE erp_px_cat_g1v2;
SELECT '>> Loading: erp_px_cat_g1v2';
LOAD DATA LOCAL INFILE '/Users/harikesh/Desktop/SqlCourse/SQL_Data_Warehouse_Project/dataset/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @id, @cat, @subcat, @maintenance
)
SET 
    id          = NULLIF(@id, ''),
    cat         = NULLIF(@cat, ''),
    subcat      = NULLIF(@subcat, ''),
    maintenance = NULLIF(@maintenance, '');
