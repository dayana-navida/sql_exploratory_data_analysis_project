/*
============================================================
SECTION : Advanced EDA
TOPIC   : Changes Over Time
PURPOSE :
- To see how the business is changing year by year
- To understand sales growth, customer growth, and quantity sold over time
- To identify overall business trends in a simple way
============================================================
*/

------------------------------------------------------------
-- YEARLY BUSINESS PERFORMANCE
------------------------------------------------------------
-- Business Question:
-- How do sales, customers, and quantity change every year?
SELECT
    DATETRUNC(YEAR, order_date) AS year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY year;
