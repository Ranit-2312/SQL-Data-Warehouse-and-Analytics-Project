/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- FIND THE FIRST AND LAST DATES OF ORDER
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_span_years
FROM gold.fact_sales;

-- FIND THE OLDEST AND YOUNGEST CUSTOMER'S AGES
SELECT
	  MAX(birthdate) AS younger,
	  EXTRACT(YEAR FROM AGE(CURRENT_DATE,MAX(birthdate))) AS age_young,
	  MIN(birthdate) AS older,
	  EXTRACT(YEAR FROM AGE(CURRENT_DATE,MIN(birthdate))) AS age_old
FROM gold.dim_customers;
