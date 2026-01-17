CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER(ORDER BY prd_start_dt,prd_key ) product_key,
pm.prd_id AS product_id,
pm.prd_key AS product_number,
pm.prd_nm AS product_name,
pm.cat_id AS category_id,
pn.CAT AS category,
pn.SUBCAT AS sub_category,
pn.MAINTENANCE AS maintenance,
pm.prd_cost AS product_cost,
pm.prd_line AS product_line,
pm.prd_start_dt AS start_date
FROM silver.prd_info pm
LEFT JOIN silver.PX_CAT_G1V pn
ON pm.cat_id = pn.ID
WHERE prd_end_dt IS NULL  ---Filter out all historical data
