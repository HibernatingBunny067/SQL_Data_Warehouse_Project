/*
=================================================
Performing over the year analysis of sales amount 
=================================================
Purpose:
	- to give the sales report per year and month
*/
use dw_gold;

-- High Level overview of sales over the years and month, query only enters presents the year and month
SELECT 
DATE_FORMAT(order_date,'%y-%m') order_date,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) total_quantity
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date,'%y-%m')
ORDER by DATE_FORMAT(order_date,'%y-%m');

-- Alternative view
-- use dw_gold;
-- SELECT 
-- YEAR(order_date) order_year,
-- MONTH(order_date) order_month,
-- SUM(sales_amount) total_sales,
-- COUNT(DISTINCT customer_key) total_customers,
-- SUM(quantity) total_quantity
-- FROM gold_fact_sales
-- WHERE order_date IS NOT NULL
-- GROUP BY YEAR(order_date), MONTH(order_date)
-- ORDER by YEAR(order_date), MONTH(order_date);

