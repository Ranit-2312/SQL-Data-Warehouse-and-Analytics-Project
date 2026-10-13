-- ===============================================================================
-- Purpose:
-- 		This report consolidates key customer metrics and behaviors

-- Highlights:
-- 1. Gathers essential fields such as names, ages, and transaction details.
-- 2. Segments customers into categories (VIP, Regular, New) and age groups.
-- 3. Aggregates customer-level metrics:
-- 		total orders
-- 		total sales
-- 		total quantity purchased
-- 		total products
-- 		lifespan (in months)
-- 4. Calculates valuable KPIs:
-- 		recency (months since last order)
-- 		average order value
-- 		average monthly spend
-- ===============================================================================

DROP VIEW IF EXISTS gold.customer_report;

CREATE VIEW gold.customer_report AS
WITH base_query AS(
	-- 1. GATHER THE REQUIRED COLUMNS
	SELECT
		f.order_number AS order_number,
		f.product_key AS product_key,
		f.order_date AS order_date,
		f.sales_amount AS sales_amount,
		f.quantity AS quantity,
		c.customer_key AS customer_key,
		c.customer_number AS customer_number,
		CONCAT(c.first_name,' ',c.last_name) AS customer_name,
		EXTRACT(YEAR FROM AGE(CURRENT_DATE,c.birthdate)) AS customer_age
	FROM 
		gold.fact_sales f LEFT JOIN gold.dim_customers c
	ON 
		f.customer_key = c.customer_key
	WHERE 
		order_date IS NOT NULL
),
customer_aggregation AS(
	-- 2. AGGREGATE THE NECESSARY COLUMNS
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		customer_age,
		MAX(order_date) AS last_order_date,
		(EXTRACT
			(YEAR FROM MAX(order_date)) - EXTRACT(YEAR FROM MIN(order_date))) * 12 
		+ 
		(EXTRACT
			(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespan,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products
	FROM
		base_query
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		customer_age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	customer_age,
	CASE
		WHEN customer_age < 20 THEN 'Under 20'
		WHEN customer_age between 20 and 29 THEN '20-29'
		WHEN customer_age between 30 and 39 THEN '30-39'
		WHEN customer_age between 40 and 49 THEN '40-49'
		ELSE '50 and above'	
	END AS age_group,
	last_order_date,
	(EXTRACT(YEAR FROM CURRENT_DATE)- EXTRACT(YEAR FROM last_order_date)) * 12 
	+ 
	(EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM last_order_date)) AS recency,
	lifespan,
	CASE
		WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
		WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	total_orders,
	total_sales,
	-- CALCULATE AVERAGE MONTHLY EXPENDITURE
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales/lifespan
	END AS avg_monthly_spend,
	total_quantity,
	total_products,
	-- CALCULATION OF AVERAGE ORDER VALUE
	CASE	
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_value
FROM 
	customer_aggregation
;
