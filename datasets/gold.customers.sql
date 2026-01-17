CREATE VIEW gold.dim_customers AS 
SELECT
ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS firstname,
ci.cst_lastname AS lastname,
cl.CNTRY AS country,
ci.cst_marital_status marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
ELSE COALESCE(ca.GEN,'n/a')
END AS gender,
ca.BDATE AS birth_date,
CAST(ci.cst_create_date AS DATE) AS create_date 
FROM silver.cust_info ci
 LEFT JOIN silver.CUST_AZ12 ca
 ON ci.cst_key = ca.CID
 LEFT JOIN silver.LOC_A101 cl
 ON ci.cst_key= cl.CID