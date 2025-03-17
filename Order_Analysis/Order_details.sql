--find top 10 highest reveue generating products 
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc




--find top 5 highest selling products in each region
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month





--for each category which month had highest sales 
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1






--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc

SELECT YEAR(orderdate) AS year, MONTH(orderdate) AS month, 
       SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY year, month
ORDER BY revenue DESC
LIMIT 1;
-- What are the top 5 best-selling products based on quantity sold?


SELECT productid, SUM(quantity) AS total_quantity
FROM ORDERS
GROUP BY productid
ORDER BY total_quantity DESC
LIMIT 5;
-- What is the average discount given across all orders?


SELECT AVG(discountpercent) AS avg_discount FROM ORDERS;

-- Which subcategory contributes the most revenue?


SELECT subcategory, SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY subcategory
ORDER BY revenue DESC
LIMIT 1;
-- 2. Customer & Order Behavior Analysis
-- How many unique customers have placed orders?


SELECT COUNT(DISTINCT orderid) AS total_customers FROM ORDERS;
-- What is the average order value (AOV)?


SELECT AVG(listprice * quantity * (1 - discountpercent/100)) AS avg_order_value FROM ORDERS;
-- What is the most popular shipping mode?


SELECT shipmode, COUNT(*) AS order_count
FROM ORDERS
GROUP BY shipmode
ORDER BY order_count DESC;
-- Which segment (customer type) generates the most revenue?


SELECT segment, SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY segment
ORDER BY revenue DESC;
-- 3. Regional & Market Insights
-- Which region generates the most sales revenue?
-- 

SELECT region, SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY region
ORDER BY revenue DESC;
-- What are the top 3 cities with the highest revenue?


SELECT city, SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY city
ORDER BY revenue DESC
LIMIT 3;


SELECT state, SUM(listprice * quantity * (1 - discountpercent/100)) AS revenue
FROM ORDERS
GROUP BY state
ORDER BY revenue DESC;
-- Which postal code has the highest number of orders?


SELECT postalcode, COUNT(*) AS total_orders
FROM ORDERS
GROUP BY postalcode
ORDER BY total_orders DESC
LIMIT 1;
-- 4. Product & Pricing Analysis
-- What is the most and least expensive product in the list price?


SELECT productid, listprice FROM ORDERS ORDER BY listprice DESC LIMIT 1; -- Most expensive
SELECT productid, listprice FROM ORDERS ORDER BY listprice ASC LIMIT 1; -- Least expensive
-- What is the average profit margin across all products?


SELECT AVG((listprice - costprice) / listprice * 100) AS avg_profit_margin FROM ORDERS;
-- Which product category has the highest average price?


SELECT category, AVG(listprice) AS avg_price
FROM ORDERS
GROUP BY category
ORDER BY avg_price DESC
LIMIT 1;
-- Which subcategory has the highest discount percentage on average?


SELECT subcategory, AVG(discountpercent) AS avg_discount
FROM ORDERS
GROUP BY subcategory
ORDER BY avg_discount DESC
LIMIT 1;
-- 5. Operational Insights & Efficiency
What is the average shipping time (days between order date and shipment)?

s
SELECT AVG(DATEDIFF(shipdate, orderdate)) AS avg_shipping_time FROM ORDERS;
-- What percentage of orders are delivered within 5 days?


SELECT 
    (SUM(CASE WHEN DATEDIFF(shipdate, orderdate) <= 5 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS on_time_delivery_rate
FROM ORDERS;
-- How does order quantity vary by day of the week?
-- 
SELECT DAYNAME(orderdate) AS order_day, COUNT(*) AS order_count
FROM ORDERS
GROUP BY order_day
ORDER BY order_count DESC;
