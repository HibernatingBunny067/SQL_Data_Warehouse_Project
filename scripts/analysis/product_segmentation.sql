/*
==================================================
Data Segmentation (Cost Range Analysis)
==================================================
Purpose:
    - Group products into specific cost segments (bins).
    - Count the distribution of products across these segments.
*/
use dw_gold;
WITH product_segments AS (
  SELECT 
  product_key,
  product_name,
  cost,
  CASE WHEN cost < 100 THEN 'Below 100'
  	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
      WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
      ELSE 'Above 1000'
  END cost_range
  FROM gold_dim_products
)

SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;
