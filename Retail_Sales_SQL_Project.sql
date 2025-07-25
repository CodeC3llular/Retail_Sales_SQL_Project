CREATE TABLE retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sales FLOAT
);

SELECT * FROM retail_sales;

SELECT 
	COUNT(*) 
FROM retail_sales;

--Data Cleaning
-- Checked for null values
SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * 
FROM retail_sales
WHERE sale_date IS NULL;

SELECT * 
FROM retail_sales
WHERE sale_time IS NULL;

SELECT * 
FROM retail_sales
WHERE customer_id IS NULL;

SELECT * 
FROM retail_sales
WHERE gender IS NULL;

SELECT * 
FROM retail_sales
WHERE age IS NULL;

SELECT * 
FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sales IS NULL;

-- Deleted NULL values
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sales IS NULL;

-- Exploratory Data Analysis 
--How many sales we have?
SELECT COUNT(*) as total_sales
FROM retail_sales;
--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales;
--How many unique categories do we have?
SELECT DISTINCT category as unique_categories
FROM retail_sales;

--Business Main Problems Answered
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND
	quantity >=4;

--3.Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sales) 
FROM retail_sales 
GROUP BY 1

SELECT 
    category,
    SUM(total_sales) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category = 'Beauty';

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sales > '1000';


--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
	category,
	gender,
	COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2
ORDER BY 1;


--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
	year,
	month,
	avg_total_sales
FROM(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sales) AS avg_total_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sales)DESC) AS rank
	FROM retail_sales
	GROUP BY year,month
	) as t1
WHERE rank =1;


--8.Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT 
	customer_id,
	SUM(total_sales) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
	category,
	COUNT(DISTINCT(customer_id)) as unique_customers
FROM retail_sales
GROUP BY category
ORDER BY category;

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between D12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
