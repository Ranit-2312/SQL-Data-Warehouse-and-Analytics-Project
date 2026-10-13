/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- WHICH CATEGORIES CONTRIBUTE THE MOST IN THE OVERALL SALES
WITH category_sales AS(
	SELECT
		p.category as category,
		SUM(f.sales_amount) AS total_sales
	FROM 
		gold.fact_sales f LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	GROUP BY 
		p.category)
SELECT 
	category, 
	total_sales, 
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((total_sales/SUM(total_sales) OVER())*100,2),'%') AS percentage_contribution
FROM category_sales
ORDER BY total_sales DESC;
