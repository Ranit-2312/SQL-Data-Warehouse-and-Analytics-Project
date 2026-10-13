/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- TOTAL SALES PER MONTN AND RUNNING TOTAL OF SALES OVER TIME
SELECT 
	order_month, 
	total_sales,
	SUM(total_sales) OVER (
		PARTITION BY EXTRACT(YEAR FROM order_month) 
		ORDER BY order_month ASC) 
	AS running_sale
FROM(
	SELECT
		DATE_TRUNC('month',order_date) AS order_month,
		SUM(sales_amount) AS total_sales
	FROM
		gold.fact_sales
	WHERE 
		order_date IS NOT NULL
	GROUP BY 
		DATE_TRUNC('month',order_date)
)t ;

-- TOTAL SALES PER YEAR AND RUNNING TOTAL OF SALES OVER TIME
SELECT 
	order_year, 
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_year ASC) 
	AS running_sale
FROM(
	SELECT
		DATE_TRUNC('year',order_date) AS order_year,
		SUM(sales_amount) AS total_sales
	FROM
		gold.fact_sales
	WHERE 
		order_date IS NOT NULL
	GROUP BY 
		DATE_TRUNC('year',order_date)
)t ;

-- AVERAGE PRICE AND RUNNING AVERAGE PRICE
SELECT 
	order_year,
	ROUND(AVG(average_sales) OVER 
		(ORDER BY order_year ASC),2)
	AS cumulative_average_sales
FROM(
	SELECT
		DATE_TRUNC('year',order_date) as order_year,
		ROUND(AVG(sales_amount),2) as average_sales
	FROM
		gold.fact_sales
	WHERE
		order_date IS NOT NULL
	GROUP BY
		DATE_TRUNC('year',order_date)
	)t;
