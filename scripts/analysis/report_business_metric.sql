/*
====================================
Report making for business metrics
====================================
Purpose:
- this query returns important stats regarding the business in a tabular form
*/

use dw_gold;
-- Total Sales
SELECT 'Total_Sales' AS Measure,
SUM(sales_amount) AS Value FROM gold_fact_sales -- around 29.4 million in sales
UNION ALL
-- Total items sold 
SELECT 'Total_Quantity' AS Measure,
SUM(quantity) AS Value FROM gold_fact_sales
UNION ALL
-- Average selling price
SELECT 'Average_Price' AS Measure,
AVG(price) AS Value FROM gold_fact_sales
UNION ALL
-- Total number of orders
SELECT 'Total_Orders(all)' AS Measure,
COUNT(DISTINCT order_number) AS Value FROM gold_fact_sales
UNION ALL
SELECT 'Total_Orders(distinct)' AS Measure,
COUNT(DISTINCT order_number) AS Value FROM gold_fact_sales
UNION ALL
-- Total number of products
SELECT 'Total_Products' AS Measure,
COUNT(DISTINCT product_key) AS Value FROM gold_dim_products
UNION ALL
-- Total number of customers
SELECT 'Total_Customers' AS Measure,
COUNT(customer_key) AS Value FROM gold_dim_customer
-- Total number of customers that have placed an order
UNION ALL
SELECT 'Total_Customers(placed an order)',
COUNT(DISTINCT customer_key) AS Value FROM gold_fact_sales; -- one customer can make more than one order
