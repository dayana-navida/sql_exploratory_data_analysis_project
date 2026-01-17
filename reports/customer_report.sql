/*
============================================================

Customer Report

============================================================

Purpose:
- To create a consolidated customer-level report
- To understand customer behavior and value
- To calculate key customer KPIs for analysis and reporting

Highlights:
1. Collects customer details, age, and transaction data
2. Groups customers into age groups and segments (VIP, Regular, New)
3. Aggregates customer metrics:
   - Total orders
   - Total sales
   - Total quantity purchased
   - Total products purchased
   - Customer lifespan (in months)
4. Calculates important KPIs:
   - Recency (months since last order)
   - Average order value
   - Average monthly spend

============================================================
*/

CREATE VIEW gold.report_customers AS

------------------------------------------------------------
-- 1. BASE QUERY
-- Collects customer and sales-level details
------------------------------------------------------------
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        c.customer_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        f.price,
        c.customer_id,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,

        -- Calculate customer age
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

------------------------------------------------------------
-- 2. CUSTOMER AGGREGATIONS
-- Aggregates data at customer level
------------------------------------------------------------
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,

        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,

        MAX(order_date) AS last_order_date,

        -- Customer lifespan in months
        DATEDIFF(MONTH, MIN(order_date), GETDATE()) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

------------------------------------------------------------
-- 3. CUSTOMER-LEVEL METRICS & SEGMENTATION
------------------------------------------------------------
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age group classification
    CASE
        WHEN age < 20 THEN 'Below 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE 'Above 50'
    END AS age_group,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Customer segmentation based on lifespan and spending
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,

    -- Recency: months since last order
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,

    -- Average Order Value
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- Average Monthly Spend
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
