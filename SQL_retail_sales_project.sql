-- Create Database for retail Sales Analysis
Create schema sql_project_p1;

USE sql_project_p1;

-- Create Tables

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

-- Data Cleaning 

-- Checked for NULL value in every column

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
        
-- Data Exploration

SHOW TABLES;

DESCRIBE retail_sales;

SELECT * FROM retail_sales;

SELECT COUNT(transactions_id) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

--

/* 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05' */

SELECT * 
FROM retail_sales
WHERE sale_date = "2022-11-05";

/* 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022 */

SELECT *
FROM retail_sales
WHERE category = "Clothing"
		AND DATE_FORMAT(sale_date, '%M-%Y') = "November-2022"
        AND quantity >= 4;
        
/* 3. Write a SQL query to calculate the total sales (total_sale) for each category. */

SELECT	category,
		ROUND(SUM(total_sale)) AS net_sales
FROM
		retail_sales
GROUP BY 1;

/* 4. Write a SQL query to find the average age of customers who purchased items 
from the 'Beauty' category. */

SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = "Beauty";

/* 5. Write a SQL query to find all transactions where the total_sale is greater 
than 1000.*/

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

/* 6. Write a SQL query to find the total number of transactions (transaction_id) 
made by each gender in each category. */

SELECT category,
		gender,
        COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category,
		gender
ORDER BY category ASC,
		total_transactions DESC;
        
/* 7. Write a SQL query to calculate the average sale for each month. 
Find out best selling month in each year. */

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

/* 8. Write a SQL query to find the top 5 customers based on the highest total sales */

SELECT customer_id,
		ROUND(SUM(total_sale)) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* 9. Write a SQL query to find the number of unique customers who purchased items 
from each category. */

SELECT category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

/* 10. Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/

SELECT * FROM sql_project_p1.retail_sales;

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
