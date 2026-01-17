/*
============================================================
FILE NAME   : date_exploration.sql
PROJECT     : Exploratory Data Analysis
PURPOSE :
- To explore date-related information in the dataset
- To understand the time range of sales data
- To identify customer age range using birth dates
- To help beginners understand date analysis
============================================================
*/

--- Find the date of the first and last order
--- This helps to understand the overall sales timeline
SELECT 
    MAX(order_date) AS last_order,
    MIN(order_date) AS first_order
FROM gold.fact_sales;


--- Find how many years of sales data are available
--- This helps to understand the length of historical data
SELECT 
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS total_years_of_sales
FROM gold.fact_sales;


--- Find the youngest and oldest customers
--- This helps to understand the customer age range
SELECT 
    MAX(birthdate) AS youngest_customer,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_age,
    MIN(birthdate) AS oldest_customer,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_age
FROM gold.dim_customers;
