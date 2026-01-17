/*
============================================================
SECTION : Advanced EDA
TOPIC   : Data Segmentation
PURPOSE :
- To group products into cost ranges
- To segment customers based on spending and relationship length
- To understand product pricing structure and customer value
============================================================
*/

------------------------------------------------------------
-- PART 1: PRODUCT COST SEGMENTATION
------------------------------------------------------------
-- Question:
-- How many products fall into each cost range?
WITH product_segments AS (
    SELECT
        product_key,
        product_name,

        -- Assign cost range to each product
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


------------------------------------------------------------
-- PART 2: CUSTOMER SEGMENTATION BASED ON SPENDING BEHAVIOR
------------------------------------------------------------
-- Customer Segments:
-- VIP     : At least 12 months history AND spending > 5000
-- Regular : At least 12 months history AND spending <= 5000
-- New     : Less than 12 months history
------------------------------------------------------------
-- Question:
-- How many customers fall into each segment?
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order_date,
        MAX(f.order_date) AS last_order_date,

        -- Customer lifespan in months
        DATEDIFF(
            MONTH,
            MIN(f.order_date),
            MAX(f.order_date)
        ) AS lifespan_months
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)

SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT
        customer_key,
        total_spending,
        lifespan_months,

        -- Assign customer segment
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000
                THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000
                THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
