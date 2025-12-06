/*
==================================================================
Fact view for the customer sales details in the dw_gold layer
==================================================================
USAGE:
SELECT * FROM gold_fact_sales

Purpose:
  - creates a view for the sales fact in the dw_gold layer completing the start schema modelling of the data 
  - one can access key information from the views and facts of this database for visualization in BI tools

*/
DROP VIEW IF EXISTS dw_gold.gold_fact_sales;
CREATE VIEW dw_gold.gold_fact_sales AS
SELECT
sd.sls_ord_num AS order_number,
pr.product_key, -- using surrogate keys from products dimensions
cu.customer_key, -- using surrogate key from customer dimension
sd.sls_order_dt AS order_date,
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales_amount,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM dw_silver.crm_sales_details sd
LEFT JOIN dw_gold.gold_dim_products pr
	on sd.sls_prd_key = pr.product_number
LEFT JOIN dw_gold.gold_dim_customer cu
	ON sd.sls_cust_id = cu.customer_id;
