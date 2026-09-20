

--Product Performance


--Top 10 Products by Revenue
SET search_path TO ecom;
with search_product as (
select p.product_id,p.product_name, 
sum(oi.line_total) as revenue
from orders o join order_items oi on oi.order_id=o.order_id
join product_variants pv on pv.variant_id=oi.variant_id
join Products p on p.product_id=pv.product_id
GROUP BY p.product_name,p.product_id
)
select * from search_product
order by revenue DESC
limit 10


--High revenue & high volume products
SET search_path TO ecom;
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.line_total) AS total_revenue,
        SUM(oi.qty) AS total_quantity_sold
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN product_variants pv
        ON pv.variant_id = oi.variant_id
    JOIN products p
        ON p.product_id = pv.product_id
    GROUP BY
        p.product_id,
        p.product_name
),

product_ranking AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank,

        DENSE_RANK() OVER (
            ORDER BY total_quantity_sold DESC
        ) AS quantity_rank

    FROM product_sales
)

SELECT *
FROM product_ranking
WHERE revenue_rank <= 10
   OR quantity_rank <= 10
ORDER BY
    revenue_rank,
    quantity_rank;



--Find cancelled and non-cancelled
SET search_path TO ecom;
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.line_total) AS total_revenue,
    SUM(oi.qty) AS total_quantity_sold,
    ROUND(
        SUM(oi.line_total) / NULLIF(SUM(oi.qty), 0),
        2
    ) AS avg_revenue_per_unit
FROM orders o
JOIN order_items oi
    ON oi.order_id = o.order_id
JOIN product_variants pv
    ON pv.variant_id = oi.variant_id
JOIN products p
    ON p.product_id = pv.product_id
WHERE LOWER(TRIM(o.status)) = 'delivered'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_revenue DESC;


--Find cancelled orders revenue
SET search_path TO ecom;

SELECT
    COUNT(*) AS refund_count,
    SUM(refund_amount) AS total_refund_amount
FROM order_refunds;

--Monthly Revenue of non-cancelled orders
SET search_path TO ecom;
with revenue AS(
    SELECT  
    date_trunc('month',created_at) as y_month,
    sum(total) as MonthlyRevenue,
    count(*) as order_count
    from orders
    where lower(trim(status)) not like 'cancelled'
    group by date_trunc('month',created_at)
    order by y_month asc
    ),
    prev_month as(
    select *,
    lag(MonthlyRevenue) over(order by y_month asc) as previous_Month_revenue
    from revenue
    )
    select to_char(y_month,'yyyy-mm') as Month ,order_count,
    round(MonthlyRevenue,2) as Monthly_Revenue,
    round((MonthlyRevenue-previous_Month_revenue)*100/previous_Month_revenue,2) as Mom_grwth_pct
    from prev_month



SET search_path TO ecom;
SELECT
    to_char(DATE_TRUNC('month', created_at),'yyyy-mm') AS revenue_month,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date,
    COUNT(*) AS order_count,
    SUM(total) AS monthly_revenue,    
    ROUND(SUM(total) / NULLIF(COUNT(*), 0), 2) AS average_order_value
FROM orders
WHERE LOWER(TRIM(status)) <> 'cancelled'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY revenue_month;

--Country Wise Revenue
SET search_path TO ecom;
with cust_demo as (
select 
--c.customer_id,c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(o.Total) as customer_spend 
FROM customers c join orders o 
ON o.customer_id=c.customer_id
--where c.country is not null
where o.status not like 'cancelled'
group by c.country
order by customer_spend DESC
)
select * from cust_demo


--Top 10 Customers
SET search_path TO ecom;
with cust_spend as (
select 
c.customer_id,c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(o.Total) as customer_spend 
FROM customers c join orders o 
ON o.customer_id=c.customer_id
--where c.country is not null
where o.status not like 'cancelled'
group by c.customer_id
order by customer_spend DESC
),cust_ranking as (
select *,
dense_rank() over (ORDER BY customer_spend desc) as cust_rank
from cust_spend
)
select cust_rank,CustomerName,country,customer_spend,
customer_id from cust_ranking
WHERE cust_rank<=10