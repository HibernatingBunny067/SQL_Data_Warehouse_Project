/*
==============================================
Silver layer data loading and transformtaions
==============================================
Usage:
	CALL load_dw_silver();
Purpose:
	- creates a stored procedure to automated the data checks and loading into dw_silver table 
	- loading is based on truncation, so one can run it more than once without duplicates
	- this script needs sql_mode set to No_substituion which maybe done with config sql file, running once per session
	- all the transformations are listed and highlighted with comments
*/

use dw_silver;
DROP PROCEDURE IF EXISTS load_dw_silver;
DELIMITER //
CREATE PROCEDURE load_dw_silver()
BEGIN
-- Inserting first Tables
SELECT '>> dw_silver.crm_cust_info';
TRUNCATE TABLE dw_silver.crm_cust_info;
INSERT INTO dw_silver.crm_cust_info(
	cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gender,
    cst_create_date
) 
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status))= 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    ELSE 'n/a'
END cst_marital_status, -- for single/married
CASE WHEN UPPER(TRIM(cst_gender))= 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
    ELSE 'n/a'
END cst_gender, -- for male/female
CASE WHEN cst_create_date IS NULL THEN NULL
	WHEN cst_create_date = CAST('0000-00-00' AS DATE)  THEN NULL -- <--- Catch the Zero Date explicitly
	ELSE CAST(cst_create_date AS DATE) 
END cst_create_date
FROM
(
SELECT 
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM dw_bronze.crm_cust_info
WHERE cst_id IS NOT NULL)t 
WHERE flag_last = 1; -- for duplicated cst_id (customer_id)
-- Inserting Second table
SELECT '>> dw_silver.crm_prd_info';
TRUNCATE TABLE dw_silver.crm_prd_info;
INSERT INTO dw_silver.crm_prd_info(
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
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
SUBSTRING(prd_key,7,LENGTH(prd_key)) AS prd_key,
prd_nm,
COALESCE(prd_cost,0) AS prd_cost,
CASE UPPER(TRIM(prd_line)) -- short hand 
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(COALESCE(DATE_SUB(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),INTERVAL 1 DAY),NULL) AS DATE) AS prd_end_dt
FROM dw_bronze.crm_prd_info;
-- Inserting Third Table
TRUNCATE TABLE dw_silver.crm_sales_details;
INSERT INTO dw_silver.crm_sales_details(
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
    -- checking valid dates
    CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS CHAR) AS DATE)
    END AS sls_order_dt,
    CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS CHAR) AS DATE)
    END AS sls_ship_dt,
    CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS CHAR) AS DATE)
    END AS sls_due_dt,
    
    -- checking for valid sales
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity, 
    CASE WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price 
    END AS sls_price
FROM dw_bronze.crm_sales_details;
-- Inserting into ERP Table 1
SELECT '>> dw_silver.erp_cust_az12';
TRUNCATE TABLE dw_silver.erp_cust_az12;
INSERT INTO dw_silver.erp_cust_az12(
	cid,
    bdate,
    gen
)
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
	ELSE cid
END AS cid,
CASE WHEN bdate > CURRENT_DATE() THEN NULL
	ELSE bdate
END AS bdate,
CASE WHEN UPPER(REGEXP_REPLACE(gen, '[[:space:]]+', '')) IN ('F','FEMALE') THEN 'Female' -- there were some empty space and special characters inside the gender column
	WHEN UPPER(REGEXP_REPLACE(gen, '[[:space:]]+', '')) IN ('M','MALE') THEN 'Male' -- removed using regular expression
	ELSE 'n/a'
END AS gen
FROM dw_bronze.erp_cust_az12;
-- Inserting into ERP Table 2
SELECT '>> dw_silver.erp_loc_a101';
TRUNCATE TABLE dw_silver.erp_loc_a101;
INSERT INTO dw_silver.erp_loc_a101(
	cid,
    cntry
)
SELECT
REPLACE(cid,'-','') cid,
CASE WHEN REGEXP_REPLACE(cntry, '[[:space:]]+', '') = 'DE' THEN 'Germany'
        WHEN REGEXP_REPLACE(cntry, '[[:space:]]+', '') IN ('US', 'USA') THEN 'United States'
        WHEN cntry IS NULL OR REGEXP_REPLACE(cntry, '[[:space:]]+', '') = '' THEN 'n/a'
        ELSE TRIM(REGEXP_REPLACE(cntry, '[[:cntrl:]]', ''))
END AS cntry
FROM dw_bronze.erp_loc_a101;
-- Inserting into ERP table 3
TRUNCATE TABLE dw_silver.erp_px_cat_g1v2;
SELECT '>> dw_silver.erp_px_cat_g1v2';
INSERT INTO dw_silver.erp_px_cat_g1v2(
	id,
    cat,
    subcat,
    maintenance
)
SELECT 
id,
cat,
subcat,
maintenance
FROM dw_bronze.erp_px_cat_g1v2;
END //
DELIMITER ;
