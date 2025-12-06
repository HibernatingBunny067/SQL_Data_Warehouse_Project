/*
======================================================
Exploring the different dimensions from the gold layer
======================================================
*/


-- all the countries present in our data 
SELECT DISTINCT TRIM(country) FROM dw_gold.gold_dim_customer;

-- exploring the various category subcategory and product_names of the products
SELECT DISTINCT category, subcategory, product_name FROM dw_gold.gold_dim_products
ORDER BY 1,2,3;

-- exploring the range of sales by time
SELECT 
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
TIMESTAMPDIFF(MONTH,MIN(order_date), MAX(order_date)) AS order_range_months
FROM dw_gold.gold_fact_sales;

-- find the youngest and oldest customer
SELECT
MIN(birthday) AS youngest_birthdate,
TIMESTAMPDIFF(YEAR,MIN(birthday),CURRENT_DATE()) youngest_age,
MAX(birthday) AS oldest_birthdate,
TIMESTAMPDIFF(YEAR,MAX(birthday),CURRENT_DATE()) oldest_age
FROM dw_gold.gold_dim_customer;
