/*
=============================================================================
Product Report View 
=============================================================================
Usage:
    - SELECT * FROM report_products;

Purpose:
    - Provides a holistic view of product performance.
    - Aggregates sales, demand (quantity), and customer reach per product.

Highlights:
    1. Identity: Retrieves product details (Category, Cost, Name).
    2. Segmentation: Classifies products into performance tiers (High/Mid/Low).
    3. Metrics: Calculates total sales, orders, and average selling price.
    4. KPIs: Computes Lifespan (market tenure), Recency, and Monthly Revenue.
*/

USE dw_gold;
DROP VIEW IF EXISTS report_products;
CREATE VIEW report_products AS 

WITH base_query AS (
    /*
    =================================================================
    1. BASE DATA EXTRACTION
    =================================================================
    - Joins Fact (Sales) and Dimension (Products) tables.
    - Filters out invalid transaction data (null dates).
    */
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold_fact_sales f
    LEFT JOIN gold_dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL 
),

product_aggregations AS (
    /*
    =================================================================
    2. PRODUCT AGGREGATION
    =================================================================
    - Summarizes metrics at the Product level.
    - Handles basic date math for Lifespan.
    */
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        
        -- Calculate Lifespan in Months
        -- MySQL uses TIMESTAMPDIFF(UNIT, Start, End) instead of SQL Server's DATEDIFF
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        
        -- Average Selling Price calculation
        -- NULLIF prevents division by zero if quantity is 0
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

/*
=================================================================
3. FINAL KPI CALCULATION & SEGMENTATION
=================================================================
- Applies business logic for segmentation.
- Computes final ratios (AOR, Monthly Revenue).
*/
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    
    -- Recency: How many months since the last sale?
    -- Uses CURRENT_DATE() for "Today" in MySQL
    TIMESTAMPDIFF(MONTH, last_sale_date, CURRENT_DATE()) AS recency_in_months,
    
    -- Performance Segmentation Logic
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    
    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
