/*
============================================================
SECTION : Advanced EDA
TOPIC   : Part to Whole Analysis
PURPOSE :
- To understand how much each product category contributes to total sales
- To identify the most important categories for the business
- To support category-level decision making
============================================================
*/

------------------------------------------------------------
-- STEP 1: CALCULATE TOTAL SALES FOR EACH CATEGORY
------------------------------------------------------------
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS category_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

------------------------------------------------------------
-- STEP 2: CALCULATE OVERALL SALES & PERCENTAGE CONTRIBUTION
------------------------------------------------------------
SELECT
    category,
    category_sales,

    -- Total sales across all categories
    SUM(category_sales) OVER () AS overall_sales,

    -- Percentage contribution of each category to total sales
    CONCAT(
        ROUND(
            (category_sales * 100.0) 
            / SUM(category_sales) OVER (),
        2),
        '%'
    ) AS percentage_of_total_sales
FROM category_sales
ORDER BY category_sales DESC;
