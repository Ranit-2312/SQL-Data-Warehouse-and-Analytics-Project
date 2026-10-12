/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- WHICH FIVE PRODUCTS GENERATE THE HIGHEST REVENUE
SELECT 
	p.product_id, p.product_name,
	SUM(f.sales_amount) AS revenue
	FROM gold.fact_sales f LEFT JOIN gold.dim_products p 
	ON f.product_key = p.product_key
GROUP BY 
  p.product_id, p.product_name
ORDER BY 
  revenue DESC
LIMIT 5;

-- WHAT ARE THE 5 WORST PERFORMING PRODUCTS IN TERMS OF SALES 
SELECT 
	p.product_id, p.product_name,
	SUM(f.sales_amount) AS revenue
FROM
  gold.fact_sales f LEFT JOIN gold.dim_products p 
	ON f.product_key = p.product_key
GROUP BY
  p.product_id, p.product_name
ORDER BY 
  revenue ASC
LIMIT 5;

-- TOP 10 CUSTOMERS GENERATING THE HIGHEST REVENUE
SELECT * FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT f.order_number) AS total_orders,
		ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT f.order_number) DESC) AS rnk
	FROM 
    gold.dim_customers c LEFT JOIN gold.fact_sales f
	  ON f.customer_key = c.customer_key
	GROUP BY 
    c.customer_key,c.first_name,c.last_name)T
	WHERE 
    rnk<=10;

-- TOP 3 CUSTOMERS WITH FEWER NUMBER OF ORDERS
SELECT * FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT f.order_number) AS total_orders,
		ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT f.order_number) ASC) AS rnk
	FROM 
    gold.dim_customers c LEFT JOIN gold.fact_sales f
	  ON f.customer_key = c.customer_key
	GROUP BY 
    c.customer_key,c.first_name,c.last_name)T
	WHERE 
    rnk<=3;
