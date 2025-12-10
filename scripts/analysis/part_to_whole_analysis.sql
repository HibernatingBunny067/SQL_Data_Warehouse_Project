/*
==================================================
Part to Whole Analysis (Market Share Calculation)
==================================================
Purpose:
    - Compare individual category performance against the grand total.
    - Calculate the percentage contribution (Market Share) of each category.
*/

use dw_gold;

WITH category_sales AS(
	SELECT
	category,
	SUM(sales_amount) total_sales
	FROM gold_fact_sales f
	LEFT JOIN gold_dim_products dp
		on f.product_key = dp.product_key
	GROUP BY category
)

SELECT 
category,
total_sales,
SUM(total_sales) OVER() overall_sales,
CONCAT(ROUND(CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()*100,2),'%') as pct_part
FROM category_sales
ORDER BY total_sales DESC;
