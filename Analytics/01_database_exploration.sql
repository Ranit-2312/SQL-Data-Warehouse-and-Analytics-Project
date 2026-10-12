/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- EXPLORE THE TABLES TO WORK WITH
SELECT * FROM gold.dim_customers;

SELECT * FROM gold.dim_products;

SELECT * FROM gold.fact_sales;

-- EXPLORE ALL OBJECTS IN THE DATABASE
SELECT * FROM information_schema."tables"
WHERE table_schema IN('silver','gold','bronze')
ORDER BY table_schema;

-- EXPLORE ALL THE COLUMNS IN THE DATABASE
SELECT * FROM information_schema."columns"
WHERE table_schema IN('silver','gold','bronze')
ORDER BY table_schema,table_name,ordinal_position;

-- EXPLORE gold.dim_customers
SELECT * FROM information_schema."columns"
WHERE table_name = 'dim_customers'
ORDER BY columns.ordinal_position;

-- EXPLORE gold.dim_products
SELECT * FROM information_schema."columns"
WHERE table_name = 'dim_products'
ORDER BY columns.ordinal_position;

-- EXPLORE gold.fact_sales
SELECT * FROM information_schema."columns"
WHERE table_name = 'fact_sales'
ORDER BY columns.ordinal_position;
