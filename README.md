# 📊 Retail Sales Analysis SQL Project

## 📌 Project Overview
This project demonstrates my ability to execute an end-to-end data analysis workflow using SQL. The goal of this project is to transform raw retail transaction data into actionable business insights. 

The analysis encompasses the entire ETL (Extract, Transform, Load) process, including database creation, handling missing/null values, exploratory data analysis (EDA), and advanced querying to uncover financial performance, customer demographics, and operational trends.

## 🛠️ Tools & Technologies
- **SQL Dialect:** MySQL
- **Concepts Applied:** Table Creation, Data Cleaning, Aggregations, Date/Time Functions, Subqueries, Common Table Expressions (CTEs), and `CASE` Statements.

---

## 🚀 Step 1: Database Setup
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
