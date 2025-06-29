# Retail Sales Analysis - SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `MySQL`  
**Schema**: `sql_project_p1`

## Objectives

1. **Set up a retail sales schema**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Schema Creation**: The project starts by creating a database named `sql_project_p1`.
- **Table Definition**: A table named `retail_sales` is created to store the sales data.
-  The table structure includes the following columns:

      `transaction ID`, `sale date`, `sale time`, `customer ID`, `gender`, `age`, `category`, `quantity`, `price per unit`, `cogs`, `total sale`.


```sql
Create schema sql_project_p1

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    age TINYINT,
    category VARCHAR(50) NOT NULL,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Unique Customer Count**: Find out how many unique customers are in the dataset.
- **Product Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

SELECT COUNT(transactions_id) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * 
FROM retail_sales
WHERE 	transactions_id IS NULL
        or sale_date IS NULL
        or sale_time IS NULL
        or customer_id IS NULL
        or gender IS NULL
        or age IS NULL
        or category IS NULL
        or quantity IS NULL
        or price_per_unit IS NULL
        or cogs IS NULL
        or total_sale IS NULL;
```

### 3. Data Analysis & Business Insights 

Below are the SQL queries used to extract business insights:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = "Clothing"
		AND DATE_FORMAT(sale_date, '%M-%Y') = "November-2022"
        AND quantity >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT	category,
		ROUND(SUM(total_sale)) AS net_sales
FROM
		retail_sales
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = "Beauty";
```

5. **Write a SQL query to find all transactions where the total sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,
		gender,
        COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category,
		gender
ORDER BY category ASC,
		total_transactions DESC;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best best-selling month in each year**:
```sql
WITH mycte AS(SELECT 	YEAR(sale_date) AS year,
						MONTHNAME(sale_date) AS month,
						ROUND(avg(total_sale), 2) AS average_sale,
						ROW_NUMBER() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(avg(total_sale), 2) DESC) AS row_num
				FROM retail_sales
				GROUP BY 1, 2
				ORDER BY average_sale DESC)
SELECT year,
		month,
		average_sale
FROM mycte
WHERE row_num = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id,
		ROUND(SUM(total_sale)) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT 
	CASE 
		WHEN HOUR(sale_time) < 12 THEN "Morning" 
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
        WHEN HOUR(sale_time) in (12, 13, 14, 15, 16, 17) THEN "Afternon"
        ELSE "Evening"
        END AS shift,
        COUNT(transactions_id) AS total_orders
FROM retail_sales
GROUP BY shift
ORDER BY total_orders DESC;
```

## Key Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Operational Insights**: Evening shift shows a significant order volume.

## Reports

- **Sales Summary**: A detailed report summarising total sales, high-value transactions, and category-wise performance breakdown.
- **Trend Analysis**: Insights on sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers, customer demographics and purchase behaviour.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behaviour, and product performance.
##
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

**Sasikumar Kamaraj**  
`sasi123.st@gmail.com`    
`www.linkedin.com/in/sasikumark123`
