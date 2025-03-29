-- SQL retail analysis
-- creating table
create table retail_sales(
				transactions_id int primary key,
				sale_date date,	
				sale_time time,
				customer_id int,
				gender varchar(10),
				age int,	
				category varchar(20),
				quantiy int,
				price_per_unit float,
				cogs float,
				total_sale float
			);

select * from retail_sales;

select count (*) from retail_sales;

-- Data Cleaning

-- To find if we have null values :-

select * from retail_sales
where transactions_id is null;

alter table retail_sales
rename quantiy to quantity;

select * from retail_sales
where 
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

-- now lets delete these rows
delete from retail_sales where
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;

select count (*) from retail_sales;

-- Data Exploration

-- How many sales we have?
select count(total_sale) as "total sale number" from retail_sales;

-- How many customers we have?
select count(distinct customer_id) as "total customer number" from retail_sales;

-- How many categories we have?
select distinct category as "Categories" from retail_sales;

-- Business Key Problems and answers

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_Sales
where sale_date = '2022-11-05';

/* Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is more than 4 in the month of Nov-2022:
*/

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;

-- Write a SQL query to calculate the total sales (total_sale) for each category

select category, 
sum(total_sale) as "Sum of total sales",
count (*) as "Total orders"
from retail_sales
group by category;


select * from retail_sales;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age), 2) as "Average age of customers purchasing Beauty Category"
from retail_sales
where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) as total_trans
from retail_sales
group by category, gender
order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1;

-- Write a SQL query to find the top 5 customers based on the highest total sales:

select * from retail_sales; 

select 
customer_id, 
sum(total_sale) as "total amount spend"
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category

select category, count(distinct customer_id) as "unique customers who purchased this category"
from retail_sales
group by 1;

/* Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17)
*/

select * from retail_sales;

with hourly_sales as (
select *,
case 
when extract (hour from sale_time) <12 then 'Morning'
when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from retail_sales
)
select shift, count(*) as total_orders
from hourly_sales
group by shift;


-- End of Analysis