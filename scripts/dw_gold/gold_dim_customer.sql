/*
============================================================
Customer Dimension fro dw_gold layer of the warehouse
============================================================
Purpose:
  - creating view in dw_gold database for customers dimension
Additional Note:  
1. checking duplicates
SELECT cst_id, COUNT(*) FROM 

2. data integration betweeen gender columns 
SELECT DISTINCT ci.cst_gndr, ca.gen FROM ..... ORDER BY 1,2
some data from crm_system is not present in the erp tables

3. Giving friendly names
4. making new surrogate key with '_key' at the end
5. finally creating a view

CAUTION:
- every successive run of this query drops the existing view and creates another one
- since views don't contain data per se, one can technically run this indefinite time and just select from this view when 
  one wishes to access the data
*/

use dw_gold;
DROP VIEW IF EXISTS gold_dim_customer;
CREATE VIEW dw_gold.gold_dim_customer AS 
SELECT 
	  ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key, -- surrogate key 
	  ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gender != 'n/a' THEN ci.cst_gender -- data integration between crm_cust and erp 
		ELSE COALESCE(ca.gen,'n/a')
	END AS new_gen,
    ca.bdate AS birthday,
    ci.cst_create_date AS create_date
FROM dw_silver.crm_cust_info ci
-- using left join to join tables according to the data integration diagram
LEFT JOIN dw_silver.erp_cust_az12 ca
	on ci.cst_key = ca.cid
LEFT JOIN dw_silver.erp_loc_a101 la
	on ci.cst_key = la.cid;
