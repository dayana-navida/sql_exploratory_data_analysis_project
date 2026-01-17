/*
============================================================
SECTION : Advanced EDA
TOPIC   : Cumulative Analysis
PURPOSE :
- To track sales growth over time
- To calculate running total of sales
- To understand sales trend using moving average
============================================================
*/

------------------------------------------------------------
-- MONTHLY SALES WITH RUNNING TOTAL AND MOVING AVERAGE
------------------------------------------------------------
-- Business Question:
-- How are sales growing month by month over time?
SELECT
    order_month,
    total_sales,
    
    -- Running total shows overall sales progress till that month
    SUM(total_sales) 
        OVER (ORDER BY order_month) AS running_total_sales,
    
    -- Moving average smooths sales trend to understand demand pattern
    AVG(avg_price) 
        OVER (ORDER BY order_month) AS moving_avg_price
FROM
(
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)
) monthly_sales
ORDER BY order_month;
