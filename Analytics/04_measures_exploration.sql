/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- FIND THE TOTAL SALES AMOUNT
SELECT SUM(sales_amount) AS total_sales_amount FROM gold.fact_sales;

-- FIND HOW MANY ITEMS ARE SOLD
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales; 

-- FIND THE AVERAGE SELLING PRICE
SELECT ROUND(AVG(sales_amount),2) AS average_sales_amount FROM gold.fact_sales;

-- FIND THE TOTAL NUMBER OF ORDERS
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- FIND THE TOTAL NUMBER OF PRODUCTS
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products;

-- FIND THE TOTAL NUMBER OF CUSTOMERS
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM gold.dim_customers;

-- FIND THE TOTAL NUMBER OF CUSTOMERS THAT HAS PLACED AN ORDER
SELECT COUNT(DISTINCT customer_key) AS customers_who_ordered FROM gold.fact_sales;

-- REPORT ON THE EXPLORED MEASURES
SELECT 
	'total_sales_amount' AS measure_name, 
	SUM(sales_amount) AS measure_value 
FROM gold.fact_sales
UNION ALL
	SELECT 'total_quantity',SUM(quantity)
FROM gold.fact_sales
UNION ALL
	SELECT 'average_sales_amount',ROUND(AVG(sales_amount),2)
FROM gold.fact_sales
UNION ALL
	SELECT 'total_orders',COUNT(DISTINCT order_number)
FROM gold.fact_sales
UNION ALL
	SELECT 'total_products',COUNT(DISTINCT product_name)
FROM gold.dim_products
UNION ALL
	SELECT 'total_customers',COUNT(DISTINCT customer_id)
FROM gold.dim_customers
UNION ALL
	SELECT 'customers_who_ordered',COUNT(DISTINCT customer_key)
FROM gold.fact_sales;
