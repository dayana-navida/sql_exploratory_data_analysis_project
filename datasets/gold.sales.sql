CREATE VIEW gold.fact_sales AS
SELECT 
ss.sls_ord_num AS order_number,
pd.product_key,  -------surrogate key
cu.customer_key,  ------surrogate key
ss.sls_order_dt AS order_date,
ss.sls_ship_dt AS shipping_date,
ss.sls_due_dt AS due_date,
ss.sls_sales AS sales_amount,
ss.sls_quantity AS quantity,
ss.sls_price AS price
FROM silver.sales_details ss
LEFT JOIN gold.dim_products pd
ON ss.sls_prd_key = pd.product_number
LEFT JOIN gold.dim_customers cu
ON ss.sls_cust_id = cu.customer_id