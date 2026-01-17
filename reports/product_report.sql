/*
============================================================

Product Report

============================================================

Purpose:
- To create a consolidated product-level report
- To understand product performance and behavior
- To calculate key product KPIs for analysis and reporting

Highlights:
1. Collects product details such as name, category, subcategory, and cost
2. Groups products based on revenue performance
3. Aggregates product metrics:
   - Total orders
   - Total sales
   - Total quantity sold
   - Total customers
   - Product lifespan (in months)
4. Calculates important KPIs:
   - Recency (months since last sale)
   - Average order revenue
   - Average monthly revenue

============================================================
*/

CREATE VIEW gold.report_products AS

------------------------------------------------------------
-- 1. BASE QUERY
-- Collects product and sales-level details
------------------------------------------------------------
WITH base_query AS (
    SELECT
        f.order_number,
        f.customer_key,
        f.order_date,
        f.sales_amount,
        f.quantity,

        p.product_key,
        p.product_number,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
),

------------------------------------------------------------
-- 2. PRODUCT AGGREGATIONS
-- Aggregates data at product level
------------------------------------------------------------
product_aggregations AS (
    SELECT
        product_number,
        product_name,
        category,
        subcategory,

        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,

        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,

        -- Product lifespan in months
        DATEDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan,

        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity
    FROM base_query
    GROUP BY
        product_number,
        product_name,
        category,
        subcategory
)

------------------------------------------------------------
-- 3. PRODUCT-LEVEL METRICS & SEGMENTATION
------------------------------------------------------------
SELECT
    product_number,
    product_name,
    category,
    subcategory,

    total_orders,
    total_customers,
    lifespan,
    total_sales,

    -- Product performance segmentation based on total sales
    CASE
        WHEN total_sales >= 50000 THEN 'High Performer'
        WHEN total_sales >= 10000 THEN 'Mid Range'
        ELSE 'Low Performer'
    END AS product_segment,

    total_quantity,
    last_order_date,

    -- Recency: months since last sale
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,

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
