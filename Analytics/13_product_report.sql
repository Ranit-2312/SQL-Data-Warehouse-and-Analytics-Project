-- ===============================================================================
-- Purpose:
--		This report consolidates key product metrics and behaviors.

-- Highlights:
-- 1. Gathers essential fields such as product name, category, subcategory, and cost.
-- 2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
-- 3. Aggregates product-level metrics:
-- 		total orders
-- 		total sales
-- 		total quantity sold
-- 		total customers (unique)
-- 		lifespan (in months)
-- 4. Calculates valuable KPIs:
-- 		recency (months since last sale)
-- 		average order revenue (AOR)
-- 		average monthly revenue
-- ===============================================================================

DROP VIEW IF EXISTS gold.product_report;

CREATE VIEW gold.product_report AS
WITH base_query AS(
	-- 1. GATHER THE REQUIRED COLUMNS
	SELECT
		f.order_number as order_number,
		f.order_date as order_date,
		f.customer_key as customer_key,
		f.sales_amount as sales_amount,
		f.quantity as quantity,
		p.product_key as product_key,
		p.product_name as product_name,
		p.category as category,
		p.sub_category as sub_category,
		p.product_cost as product_cost
	FROM 
		gold.fact_sales f LEFT JOIN gold.dim_products p  
		ON f.product_key = p.product_key
	WHERE
		f.order_date IS NOT NULL
),
product_aggregation AS(
	-- 2. PRODUCT AGGREGATION
	SELECT 
		product_key,
		product_name,
		category,
		sub_category,
		product_cost,
		(EXTRACT(YEAR FROM MAX(order_date))- EXTRACT(YEAR FROM MIN(order_date))) * 12 
		+ 
		(EXTRACT(MONTH FROM MAX(order_date)) - EXTRACT(MONTH FROM MIN(order_date))) AS lifespan,
		MAX(order_date) AS last_order_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		SUM(sales_amount) / NULLIF(SUM(quantity), 0) AS avg_selling_price
		FROM base_query
		GROUP BY
			product_key,
			product_name,
			category,
			sub_category,
			product_cost
	)
SELECT 
	product_key,
	product_name,
	category,
	sub_category,
	product_cost,
	last_order_date,
	(EXTRACT(YEAR FROM CURRENT_DATE)- EXTRACT(YEAR FROM last_order_date)) * 12 
	+ 
	(EXTRACT(MONTH FROM CURRENT_DATE) - EXTRACT(MONTH FROM last_order_date)) AS recency,
	CASE
		WHEN total_sales > 50000 THEN 'High'
		WHEN total_sales >= 10000 THEN 'Medium'
		ELSE 'Low'
	END AS product_performance,
	lifespan,
	total_orders,
	total_customers,
	total_sales,
	total_quantity,
	avg_selling_price,
	-- AVERAGE ORDER REVENUE
	CASE
		WHEN total_quantity = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_revenue,
	-- AVERAGE MONTHLY REVENUE
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales/lifespan
	END AS avg_monthly_revenue
FROM product_aggregation
;


