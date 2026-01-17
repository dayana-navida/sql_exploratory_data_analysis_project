/*
============================================================
SECTION : Advanced EDA
TOPIC   : Performance Analysis
PURPOSE :
- To analyze yearly product sales performance
- To compare current year sales with:
  1) Average sales of the product
  2) Previous year sales
- To identify growth or decline in product performance
============================================================
*/

------------------------------------------------------------
-- STEP 1: CALCULATE YEARLY SALES FOR EACH PRODUCT
------------------------------------------------------------
WITH yearly_product_sales AS (
    SELECT
        YEAR(order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_year_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        p.product_name
)

------------------------------------------------------------
-- STEP 2: COMPARE SALES WITH AVERAGE & PREVIOUS YEAR
------------------------------------------------------------
SELECT
    order_year,
    product_name,
    current_year_sales,

    -- Average sales of the product across all years
    AVG(current_year_sales)
        OVER (PARTITION BY product_name) AS avg_product_sales,

    -- Difference between current sales and average sales
    current_year_sales
        - AVG(current_year_sales)
          OVER (PARTITION BY product_name) AS diff_from_avg_sales,

    -- Flag to show above or below average performance
    CASE
        WHEN current_year_sales
             - AVG(current_year_sales) OVER (PARTITION BY product_name) > 0
            THEN 'Above Average'
        WHEN current_year_sales
             - AVG(current_year_sales) OVER (PARTITION BY product_name) < 0
            THEN 'Below Average'
        ELSE 'Average'
    END AS avg_performance_flag,

    -- Previous year sales for the same product
    LAG(current_year_sales)
        OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,

    -- Difference between current year and previous year sales
    current_year_sales
        - LAG(current_year_sales)
          OVER (PARTITION BY product_name ORDER BY order_year) AS diff_from_previous_year,

    -- Flag to show increase or decrease from previous year
    CASE
        WHEN current_year_sales
             - LAG(current_year_sales)
               OVER (PARTITION BY product_name ORDER BY order_year) > 0
            THEN 'Increase'
        WHEN current_year_sales
             - LAG(current_year_sales)
               OVER (PARTITION BY product_name ORDER BY order_year) < 0
            THEN 'Decrease'
        ELSE 'No Change'
    END AS year_on_year_flag

FROM yearly_product_sales
ORDER BY product_name, order_year;
