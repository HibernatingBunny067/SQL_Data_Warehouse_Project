# Bronze layer
- takes raw input data into designated tables
- MySQL server doesn't handle NULLs (unlike MSSQL) so we added custom NULL checks in loading script

## Details of the Data
| Table Name | Total Records |
| :--- | ---: |
| **crm_cust_info** | 18,494 |
| **crm_prd_info** | 397 |
| **crm_sales_details** | 60,398 |
| **erp_cust_az12** | 18,484 |
| **erp_loc_a101** | 18,484 |
| **erp_px_cat_g1v2** | 37 |


## DATA Flow Map
![flow map](SQL_Data_Warehouse_Project/docs/dw_bronze_map.png)
