/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- ANALYZE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING EACH PRODUCT'S SALES 
-- TO BOTH ITS AVERAGE SALES PERFORMANCE AND THE PREVIOUS YEAR'S SALES

WITH yearly_sales AS(
	SELECT 
		EXTRACT(YEAR FROM f.order_date) AS order_year,
		p.product_name as product_name,
		SUM(f.sales_amount) AS total_sales
	FROM 
		gold.fact_sales f LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	WHERE
		f.order_date IS NOT NULL
	GROUP BY
		EXTRACT(YEAR FROM f.order_date),p.product_name
)
SELECT 
	order_year,
	product_name,
	total_sales,
	ROUND(
		AVG(total_sales) OVER (PARTITION BY product_name),2) 
	AS average_price,
	total_sales - ROUND(AVG(total_sales) OVER (PARTITION BY product_name),2) AS diff_avg,
	CASE
		WHEN total_sales - ROUND(AVG(total_sales) OVER (PARTITION BY product_name),2) < 0 THEN 'below average'
		WHEN total_sales - ROUND(AVG(total_sales) OVER (PARTITION BY product_name),2) > 0 THEN 'above average'
		ELSE 'average' END 
	AS avg_change,
	LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS prev_year_sales,
	total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS prev_year_sales_difference,
	CASE
		WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'increasing'
		WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'decreasing'
		ELSE 'same as before' END 
	AS yearly_sales_stats
FROM 
	yearly_sales
ORDER BY
	product_name,order_year;
