/*
============================================================
FILE NAME   : measure_exploration.sql
PROJECT     : Exploratory Data Analysis
PURPOSE     : 
PURPOSE :
- To perform measure exploration on sales data
- To calculate key business metrics such as sales, quantity, orders, products, and customers
- To support Exploratory Data Analysis (EDA) for business understanding
- To provide a consolidated KPI summary for reporting and dashboards
============================================================
*/

------------------------------------------------------------
-- 1. TOTAL SALES
------------------------------------------------------------
-- Business Question:
-- What is the total revenue generated?
SELECT 
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;


------------------------------------------------------------
-- 2. TOTAL QUANTITY SOLD
------------------------------------------------------------
-- Business Question:
-- How many items were sold in total?
SELECT 
    SUM(quantity) AS total_quantity
FROM gold.fact_sales;


------------------------------------------------------------
-- 3. AVERAGE SELLING PRICE
------------------------------------------------------------
-- Business Question:
-- What is the average price at which products are sold?
SELECT 
    AVG(price) AS avg_price
FROM gold.fact_sales;


------------------------------------------------------------
-- 4. TOTAL NUMBER OF ORDERS
------------------------------------------------------------
-- Business Question:
-- How many unique orders were placed?
SELECT 
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


------------------------------------------------------------
-- 5. TOTAL NUMBER OF PRODUCTS
------------------------------------------------------------
-- Business Question:
-- How many products exist in the system?
SELECT 
    COUNT(product_name) AS total_products
FROM gold.dim_products;


------------------------------------------------------------
-- 6. TOTAL NUMBER OF CUSTOMERS
------------------------------------------------------------
-- Business Question:
-- How many customers are registered?
SELECT 
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;


------------------------------------------------------------
-- 7. CUSTOMERS WHO PLACED AT LEAST ONE ORDER
------------------------------------------------------------
-- Business Question:
-- How many customers have actually made purchases?
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers_with_orders
FROM gold.fact_sales;


------------------------------------------------------------
-- 8. CONSOLIDATED BUSINESS METRICS REPORT
------------------------------------------------------------
-- Purpose:
-- Single view of all key business KPIs
SELECT 
    'Total_Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT 
    'Total_Quantity',
    SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT 
    'Average_Price',
    AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT 
    'Total_Orders',
    COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT 
    'Total_Products',
    COUNT(product_name)
FROM gold.dim_products

UNION ALL

SELECT 
    'Total_Customers',
    COUNT(customer_key)
FROM gold.dim_customers

UNION ALL

SELECT 
    'Customers_With_Orders',
    COUNT(DISTINCT customer_key)
FROM gold.fact_sales;
