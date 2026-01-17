/*
============================================================
FILE NAME   : ranking_analysis.sql
PROJECT     : Exploratory Data Analysis
SECTION     : Ranking Analysis
PURPOSE     :
- To rank products and customers based on business performance
- To identify top and bottom performers using revenue and orders
- To support decision-making through comparative analysis
============================================================
*/

------------------------------------------------------------
-- RANKING ANALYSIS
------------------------------------------------------------

------------------------------------------------------------
-- 1. TOP 5 PRODUCTS BY REVENUE
------------------------------------------------------------
-- Business Question:
-- Which 5 product subcategories generate the highest revenue?
SELECT TOP 5
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC;


------------------------------------------------------------
-- 2. BOTTOM 5 PRODUCTS BY REVENUE
------------------------------------------------------------
-- Business Question:
-- Which 5 product subcategories perform worst in terms of sales?
SELECT
    subcategory,
    total_revenue
FROM (
    SELECT  
        p.subcategory,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) ASC) AS revenue_rank
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.subcategory
) ranked_products
WHERE revenue_rank <= 5;


------------------------------------------------------------
-- 3. TOP 10 CUSTOMERS BY REVENUE
------------------------------------------------------------
-- Business Question:
-- Who are the top 10 customers generating the highest revenue?
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;


------------------------------------------------------------
-- 4. CUSTOMERS WITH THE FEWEST ORDERS
------------------------------------------------------------
-- Business Question:
-- Which 3 customers have placed the fewest number of orders?
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;
