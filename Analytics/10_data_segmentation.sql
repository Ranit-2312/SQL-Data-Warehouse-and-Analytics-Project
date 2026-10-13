/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT
WITH cost_categorization AS (
	SELECT
		product_key,
		product_name,
		product_cost,
		CASE
			WHEN product_cost < 100 THEN 'Below 100'
			WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000' END
		AS cost_category
	FROM gold.dim_products
)
SELECT 
	cost_category,
	COUNT(product_key) AS total_count
FROM cost_categorization 
GROUP BY cost_category
ORDER BY MIN(product_cost);

-- Group customers into three segments based on their spending behavior:
	-- VIP: Customers with at least 12 months of history and spending more than €5,000.
	-- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	-- New: Customers with a lifespan less than 12 months.
-- And find the total number of customers by each group

WITH standard_calculation AS(
	SELECT	
		c.customer_key,
		CONCAT(c.first_name,' ',c.last_name) AS customer_name,
		SUM(f.sales_amount) AS total_expenditure,
		(EXTRACT(YEAR FROM MAX(f.order_date)) - EXTRACT(YEAR FROM MIN(f.order_date))) * 12 
	    + 
	    (EXTRACT(MONTH FROM MAX(f.order_date)) - EXTRACT(MONTH FROM MIN(f.order_date))) AS total_months
	FROM
		gold.dim_customers c LEFT JOIN gold.fact_sales f
		ON c.customer_key = f.customer_key
	GROUP BY 
		c.customer_key,
		c.first_name,
		c.last_name
),
customer_segmentation AS(
	SELECT 
		customer_key,
		customer_name, 
		CASE
			WHEN total_expenditure > 5000 AND total_months >= 12 THEN 'VIP'
			WHEN total_expenditure <= 5000 AND total_months >= 12 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment
	FROM standard_calculation
)
SELECT 
	customer_segment, 
	COUNT(customer_key) AS total_customers
FROM
	customer_segmentation
GROUP BY 
	customer_segment;
