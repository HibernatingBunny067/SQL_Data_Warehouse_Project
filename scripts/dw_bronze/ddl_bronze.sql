/*
===========================
Creating Tables in dw_bronze database 
===========================
Script Purpose:
	This script initializes 6 new tables in the dw_bronze database for raw inputting of all the data.

WARNING:
	This script was made keeping in mind that it'll be run once before starting the project, running it after you have 
    added data in the table will lead to data loss as this script drops the tables if they already exists in the 
    dw_bronze database
*/

USE dw_bronze;

DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info(
	cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gender VARCHAR(50),
    cst_create_date DATE
);

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info(
	prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details(
	sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101(
	cid VARCHAR(50),
    cntry VARCHAR(50)
);

DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12(
	cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2(
	id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
