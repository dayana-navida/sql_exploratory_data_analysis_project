/*
============================================================
FILE NAME   : dimensions_exploration.sql
PROJECT     : Exploratory Data Analysis
PURPOSE :
- To explore dimension data used in analysis
- To understand customer locations and product structure
- To identify available countries, categories, and products
- To help beginners understand dimension tables
============================================================
*/

--- Explore all countries our customers come from
--- This helps to understand customer distribution across countries
SELECT DISTINCT country 
FROM gold.dim_customers;


--- Explore all product categories and subcategories (major divisions)
--- This helps to understand the product hierarchy and classification
SELECT DISTINCT 
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;
