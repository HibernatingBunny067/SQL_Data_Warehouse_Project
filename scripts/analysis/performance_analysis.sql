/*
==================================================
Performance Analysis: Year-over-Year & Avg Comparison
==================================================
Purpose:
    - Compare each product's sales to the average sales of that product across all years.
    - Compare each product's sales to its own sales from the previous year (YoY).
*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) as order_year,
        dp.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products dp
        ON f.product_key = dp.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), dp.product_name
),

calculated_metrics AS (
    SELECT 
        order_year,
        product_name,
        current_sales,
        AVG(current_sales) OVER(PARTITION BY product_name) as avg_sales,
        LAG(current_sales, 1) OVER(PARTITION BY product_name ORDER BY order_year) as previous_year_sales
    FROM yearly_product_sales
)
SELECT 
    order_year,
    product_name,
    current_sales,
    avg_sales,
    (current_sales - avg_sales) AS diff_avg,
    CASE 
        WHEN (current_sales - avg_sales) > 0 THEN 'Above Avg'
        WHEN (current_sales - avg_sales) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_performance, 
    
    previous_year_sales,
    (current_sales - previous_year_sales) AS diff_previous_year,
    CASE 
        WHEN (current_sales - previous_year_sales) > 0 THEN 'Increase'
        WHEN (current_sales - previous_year_sales) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS yoy_trend 
FROM calculated_metrics
ORDER BY product_name, order_year;
