----Find the date of first and last order
SELECT 
MAX(order_Date) as last_order,
MIN(order_Date) as first_order
FROM gold.fact_sales

---------How many years of sales are available
SELECT 
DATEDIFF(YEAR,MIN(order_Date),MAX(order_Date))
FROM gold.fact_sales

-----Find the youngest and oldest customer
SELECT 
MAX(birthdate) as youngest_customer,
DATEDIFF(year,MAX(birthdate),GETDATE()) as youngest_age,
MIN(birthdate) as oldest_customer,
DATEDIFF(year,MIN(birthdate),GETDATE()) as oldest_age
FROM gold.dim_customers

