/*
==============================================
Cummulative analysis of sales over time (year)
==============================================
Purpose:
	- using window functions and subquery we aggregate the cummulative sales (running-total) amount of the business over the years
    - and the moving average of the price aggregated over the years
    - helps in tracking the overall progress of the business
*/

use dw_gold;
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) running_total_of_sales, -- running total per year 
AVG(avg_price) OVER(PARTITION BY order_date ORDER BY order_date) moving_average_price
FROM
(
	SELECT 
	DATE_FORMAT(order_date,'%y-%m') order_date, -- using default frame of unboudning preceeding and current row 
	SUM(sales_amount) total_sales,
    AVG(price) avg_price 
	FROM gold_fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date,'%y-%m')
	ORDER BY order_date
)t;
