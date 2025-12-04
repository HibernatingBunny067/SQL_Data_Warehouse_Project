/*
==============================
Overview of the imported data 
==============================
Purpose:
  - run this script to get the tables and there corresponding rows from the bronze layer
*/

USE dw_bronze;
SELECT 'crm_cust_info' AS Table_Name, COUNT(*) AS Total_Rows FROM dw_bronze.crm_cust_info
UNION ALL
SELECT 'crm_prd_info', COUNT(*) FROM dw_bronze.crm_prd_info
UNION ALL
SELECT 'crm_sales_details', COUNT(*) FROM dw_bronze.crm_sales_details
UNION ALL
SELECT 'erp_cust_az12', COUNT(*) FROM dw_bronze.erp_cust_az12
UNION ALL
SELECT 'erp_loc_a101', COUNT(*) FROM dw_bronze.erp_loc_a101
UNION ALL
SELECT 'erp_px_cat_g1v2', COUNT(*) FROM dw_bronze.erp_px_cat_g1v2;
