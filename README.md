# 📊 Retail Sales Analysis SQL Project

## 📌 Project Overview
This project demonstrates my ability to execute an end-to-end data analysis workflow using SQL. The goal of this project is to transform raw retail transaction data into actionable business insights. 

The analysis encompasses the entire ETL (Extract, Transform, Load) process, including database creation, handling missing/null values, exploratory data analysis (EDA), and advanced querying to uncover financial performance, customer demographics, and operational trends.

## 🛠️ Tools & Technologies
- **SQL Dialect:** MySQL
- **Concepts Applied:** Table Creation, Data Cleaning, Aggregations, Date/Time Functions, Subqueries, Common Table Expressions (CTEs), and `CASE` Statements.

---

## 🚀 Database Setup
The first step was to build the foundation. I created the database and defined the strict schema for the `retail_sales` table to ensure data integrity during the import process.

```sql
CREATE DATABASE Retail_Sales_DB;
USE Retail_Sales_DB;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

## 🧹 Data Cleaning
Real-world data is messy. After importing the CSV file, I identified 13 records with missing values. I deleted rows missing critical financial data, but preserved transaction counts by dynamically imputing the missing customer ages using a subquery.

```sql
-- Identify missing records
SELECT * FROM retail_sales
WHERE age IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

-- Remove rows with missing financial data
DELETE FROM retail_sales
WHERE quantity IS NULL OR total_sale IS NULL;

-- Impute missing ages with the average age of all customers
UPDATE retail_sales
SET age = (
    SELECT avg_age FROM (
        SELECT AVG(age) AS avg_age 
        FROM retail_sales 
        WHERE age IS NOT NULL
    ) AS temp_table
)
WHERE age IS NULL;
```
## 🔍 Exploratory Data Analysis (EDA)
Before diving into complex metrics, I ran a few basic queries to understand the shape and scope of the dataset.

```sql
-- Total number of successful transactions
SELECT COUNT(*) AS total_transactions FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Available product categories
SELECT DISTINCT category FROM retail_sales;
```
