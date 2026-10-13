# 📊 SQL Data Warehouse & Analytics Project

## Project Overview
This repository contains an end-to-end Data Warehouse migration and analytics project, transitioning raw CRM and ERP data into a fully optimized star schema using **PostgreSQL**. The project implements a standard **Medallion Architecture** (Bronze, Silver, Gold) to ingest, cleanse, transform, and analyze enterprise data, culminating in a business-ready reporting layer and interactive dashboard.

## 🏗️ Architecture & Data Pipeline

### 🥉 Bronze Layer (Raw Ingestion)
* **Purpose:** Acts as the landing zone for raw data extracted from source systems (CRM and ERP).
* **Process:** Data is ingested as-is without transformations to ensure a reliable historical source of truth.

### 🥈 Silver Layer (Data Cleansing & Standardization)
* **Purpose:** Cleanses, filters, and standardizes the raw data.
* **Key Transformations:**
  * **Data Quality:** Handled `NULL` values and removed "ghost" or garbage records (e.g., missing primary keys) using robust `WHERE` filtering.
  * **Standardization:** Applied `TRIM()`, standardized categorical values (e.g., gender and marital status), and aligned cross-system naming conventions (e.g., extracting matching category IDs using `SUBSTRING()` and `REPLACE()`).
  * **Type Casting:** Converted raw strings into proper `DATE`, `TIMESTAMP`, and `NUMERIC` formats.
  * **Deduplication:** Utilized `ROW_NUMBER()` window functions to isolate and retain only the most recent records (`last_load = 1`).

### 🥇 Gold Layer (Business-Ready Dimensional Model)
* **Purpose:** Creates highly optimized, business-facing views structured as a Star Schema.
* **Components:**
  * **Dimensions (`dim_customers`, `dim_products`):** Consolidated customer and product metadata using `LEFT JOIN`s across CRM and ERP tables, implementing `COALESCE()` for reliable fallback values.
  * **Facts (`fact_sales`):** Centralized transactional data, ensuring data integrity by explicitly checking for bad calculations or negative sales values.

## 📈 Advanced Analytics & SQL Techniques
This project leverages advanced PostgreSQL capabilities to generate actionable insights:
* **Time-Series Analysis:** Calculated product lifespans and customer engagement durations using `AGE()` and `EXTRACT()` functions.
* **Window Functions:** Implemented rolling/cumulative averages (`AVG() OVER()`) and sequential date calculations (`LEAD()`, `LAG()`).
* **Categorical Bucketing:** Used complex `CASE WHEN` statements to segment products into cost categories and ordered them by underlying numeric values for reporting.
* **Safe Aggregations:** Prevented division-by-zero errors in metric calculations (like Average Selling Price) using `NULLIF()`.

## 🛠️ Tech Stack
* **Database Engine:** PostgreSQL
* **Language:** SQL (DDL, DML, Window Functions, CTEs)
* **Data Visualization:** BI Dashboard integration for tracking KPIs, sales trends, and customer metrics.
* **Tools:** pgAdmin (Development & Querying), GitHub (Version Control)

## 🚀 How to Run the Project
1. **Database Setup:** Create a new PostgreSQL database (e.g., `datawarehouse`).
2. **Schema Creation:** Run the DDL scripts to set up the `bronze`, `silver`, and `gold` schemas.
3. **Data Loading:** Load the source CSV/flat files into the Bronze tables.
4. **Transformations:** Execute the Silver layer `INSERT INTO ... SELECT` scripts to populate the cleansed tables.
5. **View Generation:** Run the Gold layer `CREATE VIEW` scripts to build the final Star Schema.
6. **Analytics:** Execute the provided aggregation and reporting queries to feed the dashboard.

## 📝 Note on SQL Dialect
This project includes optimized syntax specifically adapted for PostgreSQL (e.g., `DROP VIEW IF EXISTS`, `COALESCE`, `INTERVAL`, and `AGE()`), showcasing a successful syntax migration from SQL Server/T-SQL environments.
