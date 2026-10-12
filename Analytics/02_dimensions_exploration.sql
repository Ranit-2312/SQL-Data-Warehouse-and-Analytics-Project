/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- EXPLORE ALL COUNTRIES OUR CUSTOMERS BELONG TO
SELECT 
    DISTINCT(country) 
FROM gold.dim_customers;

-- EXPLORE ALL CATEGORIES ALONG WITH THE SUBCATEGORIES 
SELECT 
    DISTINCT category 
FROM gold.dim_products;

-- EXPLORE ALL CATEGORIES ALONG WITH THE SUBCATEGORIES
SELECT 
    DISTINCT category,sub_category 
FROM gold.dim_products
ORDER BY 
    category,sub_category;

-- EXPLORE ALL CATEGORIES,SUBCATEGORIES AND THE PRODUCT NAMES 
SELECT 
    DISTINCT category,
    sub_category,
    product_name 
FROM gold.dim_products
ORDER BY 
    category,sub_category,product_name;
