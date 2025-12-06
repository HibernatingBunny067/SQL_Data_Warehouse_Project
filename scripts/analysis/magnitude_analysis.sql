/*
========================================================
Segemented business metrics over different dimensions
========================================================
USAGE:
  - run this script once to get mentioned metrics in tabular form
*/
USE dw_gold;

-- total_customers per country, ordered by COUNT arranged in descending order 
SELECT
country,
COUNT(customer_key) AS total_customers
FROM gold_dim_customer
GROUP BY country
ORDER BY total_customers DESC;

-- total customers grouped by gender 
SELECT
new_gen,
COUNT(customer_key) AS total_customers
FROM gold_dim_customer
GROUP BY new_gen
ORDER BY total_customers DESC;

-- total products grouped by category
SELECT 
category,
COUNT(product_key) as total_products
FROM gold_dim_products
GROUP BY category;

-- average cost in each category
SELECT 
category,
AVG(cost) Avg_Product_cost
FROM gold_dim_products
GROUP BY category;

-- total sales in each category
SELECT
p.category,
SUM(f.sales_amount) AS total_sales
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
	on f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- total revenue per customer
SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_sales
FROM gold_fact_sales f
LEFT JOIN gold_dim_customer c
	on f.customer_key = c.customer_key
GROUP BY 
	c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_sales DESC;

-- distribution of sold items across countries
SELECT 
c.country,
SUM(f.quantity) AS total_sold_items
FROM gold_fact_sales f
LEFT JOIN gold_dim_customer c
	on f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
