# Bronze layer
- takes raw input data into designated tables
- MySQL server doesn't handle NULLs (unlike MSSQL) so we added custom NULL checks in loading script

## Details of the Data
'crm_cust_info','18494'
'crm_prd_info','397'
'crm_sales_details','60398'
'erp_cust_az12','18484'
'erp_loc_a101','18484'
'erp_px_cat_g1v2','37'


## DATA Flow Map
![flow map](SQL_Data_Warehouse_Project/docs/dw_bronze_map.png)
