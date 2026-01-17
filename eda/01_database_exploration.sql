/*
============================================================
FILE NAME   : database_exploration.sql
PROJECT     : Exploratory Data Analysis
PURPOSE :
- To explore the database structure before starting analysis
- To identify available tables and columns in the database
- To understand how data is organized across schemas
- To help beginners get familiar with the database
============================================================
*/
--- Explore all objects in the database
--- This helps to see all tables and views available in the database
SELECT * 
FROM INFORMATION_SCHEMA.TABLES;

--- Explore all columns in the database
--- This helps to understand the structure of each table
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS;
