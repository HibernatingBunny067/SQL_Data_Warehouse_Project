/*
================================================================
Customer Segmentation Analysis (Spending & Loyalty)
================================================================
Purpose:
    - Segment customers into strategic groups (VIP, Regular, New) based on 
      their purchasing history and tenure.
    - Analyze the distribution (count) of customers across these segments.
*/

use dw_gold;

WITH customer_spending AS (
	SELECT 
	dc.customer_key,
	SUM(f.sales_amount) total_spending,
	MIN(order_date) first_order,
	MAX(order_date) last_order,
	TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) life_span
	FROM gold_fact_sales f
	LEFT JOIN gold_dim_customer dc
		ON f.customer_key = dc.customer_key
	GROUP BY dc.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) total_customers
FROM(
	SELECT 
	customer_key,
	total_spending,
	life_span,
	CASE WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN life_span >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
	FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customers DESC;
