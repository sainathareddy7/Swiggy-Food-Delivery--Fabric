SELECT TOP (100) [order_id],
			[order_time],
			[delivery_time],
			[restaurant],
			[cuisine],
			[total_amount],
			[rating_num],
			[location],
			[city],
			[distance_km],
			[online_order],
			[book_table],
			[online_order_cat],
			[book_table_cat],
			[delivery_minutes],
			[load_ts]
FROM [Swiggy_WH].[dbo].[silver_food_orders];

--1. Total Revenue: What is the total revenue generated across all orders? 
-- Total Revenue (T‑SQL) 
SELECT ROUND(SUM(total_amount), 2) AS total_revenue_inr
FROM dbo.silver_food_orders;
--2. Top Cuisines: Which are the top 5 cuisines by total revenue? 
SELECT TOP 5 cuisine, ROUND(SUM(total_amount), 2) AS total_revenue_inr FROM dbo.silver_food_orders
GROUP BY total_amount ,cuisine
ORDER BY total_amount desc
--3. Revenue by Location: Which area in Bengaluru generated the highest sales? 

SELECT TOP 1 
 location, ROUND(SUM(total_amount), 2) AS total_revenue_inr
  FROM dbo.silver_food_orders
  WHERE city = 'Bengaluru' 
GROUP BY location
ORDER BY sum(total_amount) desc;
-- Bengaluru: highest revenue location(s) using DENSE_RANK
WITH revenue AS (
    SELECT
        location,
        SUM(total_amount) AS total_revenue_inr
    FROM dbo.silver_food_orders
    WHERE city = 'Bengaluru'      
    GROUP BY location
)
SELECT
    location,
    total_revenue_inr
FROM (
    SELECT
        location,
        total_revenue_inr,
        DENSE_RANK() OVER (ORDER BY total_revenue_inr DESC) AS rnk
    FROM revenue
) r
WHERE r.rnk = 1                  
ORDER BY total_revenue_inr DESC;

--4. Average Order Value (AOV): What is the average amount spent per order? 
SELECT AVG(total_amount) avg_order_value
FROM dbo.silver_food_orders;

--5. High-Value Orders: List the top 10 orders with the highest total_amount. 
SELECT TOP 5 *  FROM dbo.silver_food_orders;
select top 10 order_id,
sum(total_amount) as total_amt from dbo.silver_food_orders
group by order_id 
order by sum(total_amount) desc
;
with revenue as (
select order_id,
sum(total_amount) as total_amt 
from dbo.silver_food_orders
group by order_id
)
select order_id,total_amt from
(
select order_id,total_amt,
dense_rank () over(order by total_amt desc) as rnk 
from revenue) r
where r.rnk<=10
order by total_amt desc;

--2ategory: Operational Efficiency 
--6. Average Delivery Time: What is the average delivery time (in minutes) for all online orders? 
-- Avg Delivery Time (Warehouse T‑SQL)
SELECT ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
FROM dbo.silver_food_orders
WHERE online_order = 1 AND delivery_minutes IS NOT NULL;
--7. Fastest Restaurants: Which 5 restaurants have the fastest average delivery time? 
SELECT top 5 
restaurant,
ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
FROM dbo.silver_food_orders
WHERE online_order = 1 AND delivery_minutes IS NOT NULL
group by restaurant
order by ROUND(AVG(delivery_minutes), 2)desc ;
--8. Location Delays: Which location has the highest average delivery time? 
SELECT top 1
location,
ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
FROM dbo.silver_food_orders
WHERE online_order = 1 AND delivery_minutes IS NOT NULL
group by location
order by ROUND(AVG(delivery_minutes), 2)desc ;
--with dense rank
with avg_delivery  as (
SELECT 
location,
ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
FROM dbo.silver_food_orders
WHERE online_order = 1 AND delivery_minutes IS NOT NULL
group by location
)
select location, avg_delivery_minutes from 
(select location, avg_delivery_minutes ,
dense_rank() over( order by avg_delivery_minutes desc) as rnk 
from avg_delivery
) rn
where rn.rnk=1
order by avg_delivery_minutes desc;
--9. Distance Impact: What is the average delivery time for orders traveling more than 10km? --38.52 

SELECT 
ROUND(AVG(delivery_minutes), 2) AS avg_delivery_minutes
FROM dbo.silver_food_orders
WHERE 1=1 --online_order = 1 AND delivery_minutes IS NOT NULL
and distance_km > '10'
;
--

--10. Delivery Success Rate: How many orders have a valid delivery_time compared to the total online_order = 'Yes' count? 
SELECT
    SUM(CASE WHEN online_order = 1 THEN 1 ELSE 0 END) AS online_orders,
    SUM(CASE WHEN online_order = 1 AND delivery_time IS NOT NULL THEN 1 ELSE 0 END) AS delivered_with_time,
    ROUND(
        100.0 * SUM(CASE WHEN online_order = 1 AND delivery_time IS NOT NULL THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN online_order = 1 THEN 1 ELSE 0 END), 0),
        2
    ) AS success_rate_pct
FROM dbo.silver_food_orders;


--Category: Customer Behavior 
--11. Order Mode: What is the percentage split between "Online" vs "Offline" orders?

SELECT 
  CASE WHEN online_order = 1 THEN 'Online' ELSE 'Offline' END AS order_mode,
  COUNT(*) AS orders,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM dbo.silver_food_orders
GROUP BY online_order;
--12. Booking Influence: Do customers who "Book a Table" spend more on average than those who don't? 

SELECT
    CASE WHEN book_table = 1 THEN 'Booked' ELSE 'Not Booked' END AS book_status,
    ROUND(AVG(CAST(total_amount AS float)), 2) AS avg_spend_inr,
    COUNT(*) AS orders
FROM dbo.silver_food_orders
GROUP BY CASE WHEN book_table = 1 THEN 'Booked' ELSE 'Not Booked' END
ORDER BY avg_spend_inr DESC;
--select top 50 * from dbo.silver_food_orders;

--13. Peak Order Hours: During which hour of the day do most orders occur? 

WITH hourly AS (
    SELECT 
        DATEPART(HOUR, order_time) AS order_hour,
        COUNT(*) AS orders
    FROM dbo.silver_food_orders
    WHERE order_time IS NOT NULL
    GROUP BY DATEPART(HOUR, order_time)
)
SELECT order_hour, orders
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY orders DESC) AS rnk
    FROM hourly
) r
WHERE r.rnk = 1
ORDER BY order_hour;  -- if multiple hours tie for #1
--14. Popular Locations: Which 5 locations have the highest volume of orders? 

Select top 5 location,
count(order_id) as cnt
from dbo.silver_food_orders
group by location
order by count(order_id) desc;
--15. Quantity Trends: What is the average ordered_qty per order for different cuisine types? 

with avgcnt as (
select cuisine,
count((order_id)) as ord_cnt
from dbo.silver_food_orders
group by cuisine
)
select cuisine, avg(ord_cnt)  
from avgcnt
GROUP by cuisine;
-- Average ordered_qty per order for each cuisine
WITH order_level AS (
    SELECT
        cuisine,
        order_id,
        count(order_id) AS order_qty  -- total qty within the order
    FROM dbo.silver_food_orders
    GROUP BY cuisine, order_id
)
SELECT
    cuisine,
    AVG(order_qty * 1.0) AS avg_ordered_qty_per_order
FROM order_level
GROUP BY cuisine
ORDER BY cuisine;


SELECT
    cuisine,
    AVG(order_id * 1.0) AS avg_ordered_qty_per_order
FROM dbo.silver_food_orders
GROUP BY cuisine
ORDER BY cuisine;

--Category: Quality & Ratings 
--16. Top Rated: Which restaurants have an average rating higher than 4.5? 
SELECT 
restaurant, avg(rating_num) rat
FROM dbo.silver_food_orders
group by restaurant 
--order by avg(rating_num) DESC
HAVING  avg(rating_num)>4.5
;
SELECT
    restaurant,
    AVG(TRY_CAST(rating_num AS float)) AS avg_rating
FROM dbo.silver_food_orders
GROUP BY restaurant
HAVING AVG(TRY_CAST(rating_num AS float)) > 4.5
ORDER BY avg_rating DESC;
--17. Cuisine Satisfaction: Which cuisine has the highest average customer rating? 

WITH cuisine_avg AS (
    SELECT
        COALESCE(cuisine, 'Unknown') AS cuisine,
        AVG(TRY_CAST(rating_num AS float)) AS avg_rating
    FROM dbo.silver_food_orders
    WHERE TRY_CAST(rating_num AS float) IS NOT NULL
    GROUP BY COALESCE(cuisine, 'Unknown')
)
SELECT TOP (1) WITH TIES
    cuisine,
    avg_rating
FROM cuisine_avg
ORDER BY avg_rating DESC;

--18. Rating vs. Spend: Is there a correlation between high spending and high ratings? 
/* Correlation in Warehouse = corr(x,y) = (avg(x*y) - avg(x)*avg(y)) / (stdev(x) * stdev(y)) */
WITH s AS (
  SELECT 
    AVG(CAST(total_amount AS float)) AS ax,
    AVG(CAST(rating_num  AS float)) AS ay,
    AVG(CAST(total_amount * rating_num AS float)) AS axy,
    STDEV(CAST(total_amount AS float)) AS sx,
    STDEV(CAST(rating_num  AS float)) AS sy
  FROM dbo.silver_food_orders
  WHERE total_amount IS NOT NULL AND rating_num IS NOT NULL
)
SELECT (axy - ax*ay) / NULLIF(sx*sy, 0) AS corr_spend_rating
FROM s;
--19. Low Rating Audit: List the restaurants with more than 10 orders that have an average rating below 3.0.

with cte as (
select  restaurant,
count(*) ord_cnt,
AVG(TRY_CAST(rating_num AS float)) AS avg_rating
from dbo.silver_food_orders
group by restaurant )
select restaurant,avg_rating
from cte
where avg_rating <3;
--20. City-Wide Quality: What is the average rating of food delivery across the entire city of Bengaluru? 
select top 5 * from dbo.silver_food_orders;
select 
AVG(TRY_CAST(rating_num AS float)) AS avg_rating
from dbo.silver_food_orders
where city='Bengaluru'


