# Bronze layer
- takes raw input data into designated tables
- MySQL server doesn't handle NULLs (unlike MSSQL) so we added custom NULL checks in loading script

## DATA Flow Map
![flow map](SQL_Data_Warehouse_Project/docs/dw_bronze_map.png)
