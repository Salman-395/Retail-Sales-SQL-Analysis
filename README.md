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
## 📈 Business & Financial Analysis
These queries answer core business questions regarding revenue, profitability, and customer behavior.

### 💰 Profitability by Category
I calculated the actual net profit per category by subtracting the Cost of Goods Sold (COGS).

```sql
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    SUM(cogs) AS total_cost,
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

### 📅 Monthly Sales Trend
Grouping dates to find seasonal trends and track revenue month-over-month.

```sql
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(total_sale) AS monthly_revenue,
    COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sale_month ASC;
```

### 🚻 Spending Habits by Gender
Understanding which demographic drives higher transaction volume and total revenue.

```sql
SELECT 
    gender,
    COUNT(transactions_id) AS total_purchases,
    SUM(total_sale) AS total_spent,
    AVG(total_sale) AS avg_spent_per_transaction
FROM retail_sales
GROUP BY gender;
```

##🔬 Advanced Analytics
Using advanced SQL techniques to extract deeper operational insights.

###👥 Customer Age Segmentation (Using CTEs)
I utilized a Common Table Expression (CTE) combined with a CASE statement to categorize customers into age brackets, making the data highly actionable for the marketing team.

```sql
WITH Age_Demographics AS (
    SELECT 
        transactions_id,
        customer_id,
        total_sale,
        CASE 
            WHEN age < 25 THEN 'Youth (Under 25)'
            WHEN age BETWEEN 25 AND 40 THEN 'Young Adults (25-40)'
            WHEN age BETWEEN 41 AND 60 THEN 'Middle-Aged (41-60)'
            ELSE 'Seniors (60+)'
        END AS age_group
    FROM retail_sales
)
SELECT 
    age_group,
    COUNT(transactions_id) AS total_transactions,
    SUM(total_sale) AS total_revenue
FROM Age_Demographics
GROUP BY age_group
ORDER BY total_revenue DESC;
```

###🏆 Top 5 VIP Customers
Identifying the highest-spending customers by lifetime value.

```sql
SELECT 
    customer_id,
    gender,
    age,
    SUM(total_sale) AS lifetime_value
FROM retail_sales
GROUP BY customer_id, gender, age
ORDER BY lifetime_value DESC
LIMIT 5;
```
###⏰ Peak Shopping Hours
By extracting the hour from the timestamp, I identified the busiest times of day to help store managers optimize staff scheduling.

```sql
SELECT 
    HOUR(sale_time) AS hour_of_day,
    COUNT(transactions_id) AS foot_traffic,
    SUM(total_sale) AS revenue_generated
FROM retail_sales
GROUP BY HOUR(sale_time)
ORDER BY hour_of_day DESC;
```
