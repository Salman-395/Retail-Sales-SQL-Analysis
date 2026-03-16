-- 1. Create the Database and Table
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

-- 2. Identify Missing Data
SELECT * FROM retail_sales
WHERE age IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

-- 3. Data Cleaning
DELETE FROM retail_sales
WHERE quantity IS NULL OR total_sale IS NULL;

-- 4. For missing ages, we will fill them with the average age of all customers.
UPDATE retail_sales
SET age = (
    SELECT avg_age FROM (
        SELECT AVG(age) AS avg_age 
        FROM retail_sales 
        WHERE age IS NOT NULL
    ) AS temp_table
)
WHERE age IS NULL;

-- 5. How many total sales do we have?
SELECT COUNT(*) AS total_transactions FROM retail_sales;

-- 6. How many unique customers made purchases?
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- 7. What are the unique product categories?
SELECT DISTINCT category FROM retail_sales;

-- 8. Total Revenue and Profit Margin by Category
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    SUM(cogs) AS total_cost,
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- 9. Sales Trend Over Time (Monthly Revenue)
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS sale_month,
    SUM(total_sale) AS monthly_revenue,
    COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sale_month ASC;

-- 10. Who buys more? Male vs. Female Spending Habits
SELECT 
    gender,
    COUNT(transactions_id) AS total_purchases,
    SUM(total_sale) AS total_spent,
    AVG(total_sale) AS avg_spent_per_transaction
FROM retail_sales
GROUP BY gender;

-- 11. Customer Demographics: Segmenting Customers into Age Groups using CTEs
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

-- 12. Identifying Top 5 Customers by Lifetime Value
SELECT 
    customer_id,
    gender,
    age,
    SUM(total_sale) AS lifetime_value
FROM retail_sales
GROUP BY customer_id, gender, age
ORDER BY lifetime_value DESC
LIMIT 5;

-- 13. Finding the Peak Shopping Hours
SELECT 
    HOUR(sale_time) AS hour_of_day,
    COUNT(transactions_id) AS foot_traffic,
    SUM(total_sale) AS revenue_generated
FROM retail_sales
GROUP BY HOUR(sale_time)
ORDER BY hour_of_day DESC;