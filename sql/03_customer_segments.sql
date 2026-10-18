
--Total No of Customers (10,000)
SET search_path TO ecom;
select count(distinct customer_id)
from customers;

--Customer Distribution by Country
SET search_path TO ecom;
with customer_country as(
select 
CASE
    WHEN country IS NULL
         OR TRIM(country) = ''
         OR UPPER(TRIM(country)) IN ('N/A', 'NA', 'UNKNOWN')
    THEN 'Unknown / Not Provided'
    ELSE TRIM(country)
END AS country_name
from customers
)
select country_name,
count(*) as Total_no_Customers,
round(count(*)::numeric/sum(count(*))over()*100,2) as pct_per_country
from customer_country
group by country_name
order by Total_no_Customers DESC;

--Customers with the highest order frequency
SET search_path TO ecom;
select distinct c.customer_id,c.first_name,
COUNT(DISTINCT o.order_id)
from orders o join customers c
on o.customer_id=c.customer_id
group by c.customer_id
order by 3 desc;

-- Customer Purchase Frequency
-- Calculate one-time purchasers and repeat-purchase behavior
SET search_path TO ecom;
WITH customer_order_counts AS (
    SELECT
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    LEFT JOIN orders o
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    COUNT(*) FILTER (
        WHERE order_count = 1
    ) AS one_time_customers,

    COUNT(*) FILTER (
        WHERE order_count > 0
    ) AS customers_with_orders,

    COUNT(*) AS total_customers,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count = 1)
        / NULLIF(COUNT(*) FILTER (WHERE order_count > 0), 0),
        2
    ) AS one_time_share_among_customers_with_orders_pct,

    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count = 1)
        / NULLIF(COUNT(*), 0),
        2
    ) AS one_time_share_among_all_customers_pct

FROM customer_order_counts;


--Top 10 Customers
SET search_path TO ecom;
with cust_spend as (
select 
c.customer_id as customer_id,
c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(oi.line_total) as gross_realized_revenue 
FROM customers c join orders o 
ON o.customer_id=c.customer_id join
order_items oi on oi.order_id=o.order_id
where lower(trim(o.status)) = 'delivered'
group by c.customer_id
),
cust_ranking as (
select customer_id,CustomerName,country,
gross_realized_revenue,
dense_rank() over (ORDER BY gross_realized_revenue desc) as cust_rank
from cust_spend
)
select cust_rank,CustomerName,customer_id,
CASE
    WHEN country IS NULL
         OR TRIM(country) = ''
         OR UPPER(TRIM(country)) IN ('N/A', 'NA', 'UNKNOWN')
    THEN 'Unknown / Not Provided'
    ELSE TRIM(country)
END AS country,
round(gross_realized_revenue,2) as gross_realized_revenue
from cust_ranking
WHERE cust_rank<=10;
