SET search_path TO ecom;

--Product Performance


--Top 10 Products by Gross Realized Revenue
SET search_path TO ecom;
with search_product as (
select p.product_id,p.product_name, 
sum(oi.line_total) as gross_realized_revenue,
SUM(oi.qty) AS units_sold,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(
    SUM(oi.line_total) / NULLIF(SUM(oi.qty), 0),
    2
) AS avg_revenue_per_unit
from orders o join order_items oi on oi.order_id=o.order_id
join product_variants pv on pv.variant_id=oi.variant_id
join Products p on p.product_id=pv.product_id
WHERE LOWER(TRIM(o.status)) = 'delivered'
GROUP BY p.product_name,p.product_id
)
select * from search_product
order by gross_realized_revenue DESC
limit 10

--Top 10 products in Pipeline
SET search_path TO ecom;
with search_product as (
select p.product_id,p.product_name, 
sum(oi.line_total) as pipeline_revenue,
SUM(oi.qty) AS units_sold,
COUNT(DISTINCT o.order_id) AS orders,
ROUND(SUM(oi.line_total) / NULLIF(SUM(oi.qty), 0),2) AS avg_revenue_per_unit
from orders o join order_items oi on oi.order_id=o.order_id
join product_variants pv on pv.variant_id=oi.variant_id
join Products p on p.product_id=pv.product_id
WHERE LOWER(TRIM(o.status)) not in ('delivered','cancelled')
GROUP BY p.product_name,p.product_id
)
select * from search_product
order by pipeline_revenue DESC
limit 10




SET search_path TO ecom;
select DISTINCT status from orders

SELECT
    rr.return_id,
    rr.order_id,
    ri.variant_id,
    ri.qty AS returned_qty
FROM return_requests rr
JOIN return_items ri
    ON ri.return_id = rr.return_id
LIMIT 20;


SET search_path TO ecom;
SELECT
    rr.return_id,
    rr.order_id,
    ri.variant_id,
    ri.qty AS returned_qty,
    oi.qty AS ordered_qty,
    oi.unit_price,
    oi.line_total
FROM return_requests rr
JOIN return_items ri
    ON ri.return_id = rr.return_id
JOIN order_items oi
    ON oi.order_id = rr.order_id
   AND oi.variant_id = ri.variant_id
ORDER BY rr.return_id;

SET search_path TO ecom;

SELECT
    status,
    COUNT(*) AS refund_records,
    ROUND(SUM(amount), 2) AS total_refund_amount
FROM refunds
GROUP BY status
ORDER BY refund_records DESC;
--Realized revenue after refunds
SET search_path TO ecom;
with delivered_revenue as(
    select sum(oi.line_total) as gross_realized_revenue
    from orders o join order_items oi ON
    o.order_id=oi.order_id
    where lower(trim(o.status))='delivered'
),
refund_calculation as (
    select 
    sum(amount) as refund_amount
    from refunds 
    where lower(trim(status))<>'failed'
)
select 
round(gross_realized_revenue,2) as gross_realized_revenue,
round(refund_amount,2) as total_refunds,
round(gross_realized_revenue-refund_amount,2) as net_realized_revenue,
round(refund_amount *100/nullif(gross_realized_revenue,0),2)as refund_rate_pct
FROM delivered_revenue,refund_calculation




--High revenue Vs high volume products
SET search_path TO ecom;
WITH product_sales AS (
    SELECT
        p.product_id,p.product_name,
    --    pv.variant_id,
        SUM(oi.line_total) AS gross_revenue,
        SUM(oi.qty) AS units_sold
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
    --   pv.variant_id
),
product_ranking AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY gross_revenue DESC
        ) AS revenue_rank,

        DENSE_RANK() OVER (
            ORDER BY units_sold DESC
        ) AS volume_rank

    FROM product_sales
)

SELECT *,CASE
    WHEN revenue_rank <= 10
         AND volume_rank <= 10
        THEN 'High Revenue & High Volume'

    WHEN revenue_rank <= 10
         AND volume_rank > 10
        THEN 'High Revenue & Low Volume'

    WHEN revenue_rank > 10
         AND volume_rank <= 10
        THEN 'Low Revenue & High Volume'

    ELSE 'Other'
END AS product_profile
FROM product_ranking
WHERE revenue_rank <= 10
   OR volume_rank <= 10
ORDER BY
    revenue_rank,
    volume_rank;

--Incorporate returns/refunds
SET search_path TO ecom;
SELECT
    LOWER(TRIM(status)) AS return_status,
    COUNT(*) AS request_count
FROM return_requests
GROUP BY LOWER(TRIM(status))
ORDER BY request_count DESC;


--Monthly Revenue from delivered orders
SET search_path TO ecom;
with revenue AS(
    SELECT  
    date_trunc('month',created_at) as y_month,
    sum(total) as MonthlyRevenue,
    count(*) as order_count,
    lower(trim(status)) as status1
    from orders
    where lower(trim(status)) like 'delivered'

    --where lower(trim(status)) not like 'cancelled'
    group by date_trunc('month',created_at),lower(trim(status))
    order by y_month asc
    ),
    prev_month as(
    select *,
    lag(MonthlyRevenue) over(order by y_month asc) as previous_Month_revenue
    from revenue
    )
    select to_char(y_month,'yyyy-mm') as Month ,order_count,
    round(MonthlyRevenue,2) as Monthly_Revenue,
    round((MonthlyRevenue-previous_Month_revenue)*100/previous_Month_revenue,2) as Mom_grwth_pct,
    status1
    from prev_month



SET search_path TO ecom;

with binning as(
    SELECT
    date_bin(
        INTERVAL '14 days',
        created_at,
        TIMESTAMPTZ '2026-03-16 00:00:00+00'
    ) AS bin_start,
    COUNT(*) AS order_count,
    SUM(total) AS revenue
FROM orders
WHERE LOWER(TRIM(status)) = 'delivered'
group by bin_start
),
lagging as (
    select bin_start,
    bin_start + INTERVAL '14 days' AS bin_end,
    order_count,revenue,
    lag(revenue) over (order by bin_start asc) as prev_bin_revenue
    from binning 
)
select *,
round((revenue-prev_bin_revenue)*100.0/prev_bin_revenue,2) as grwth_pct
from lagging
ORDER BY bin_start;


SELECT
    to_char(DATE_TRUNC('month', created_at),'yyyy-mm') AS revenue_month,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date,
    COUNT(*) AS order_count,
    SUM(total) AS monthly_revenue,    
    ROUND(SUM(total) / NULLIF(COUNT(*), 0), 2) AS average_order_value,
    LOWER(TRIM(status))
FROM orders
WHERE LOWER(TRIM(status)) <>'cancelled' and lower(trim(status)) ='delivered'
GROUP BY DATE_TRUNC('month', created_at), LOWER(TRIM(status))
ORDER BY revenue_month;

--Country Wise Revenue
SET search_path TO ecom;

WITH cust_demo AS (
SELECT 
    c.country,
    SUM(oi.line_total) AS gross_revenue
    FROM customers c JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    GROUP BY c.country
),
refund_calculation AS (
    SELECT
        c.country,
        SUM(r.amount) AS refund_amount
        FROM customers c JOIN orders o
        ON o.customer_id = c.customer_id
        JOIN refunds r
        ON r.order_id = o.order_id
        WHERE LOWER(TRIM(o.status)) = 'delivered'
        AND LOWER(TRIM(r.status)) <> 'failed'

    GROUP BY c.country
)

SELECT 
    d.country,
    ROUND(d.gross_revenue, 2) AS gross_revenue,
    ROUND(COALESCE(r.refund_amount, 0), 2) AS total_refunds,
    ROUND(d.gross_revenue - COALESCE(r.refund_amount, 0),2) AS net_realized_revenue,
    ROUND(COALESCE(r.refund_amount, 0) * 100/ NULLIF(d.gross_revenue, 0),2) AS revenue_refund_rate

FROM cust_demo d
LEFT JOIN refund_calculation r
    ON d.country = r.country
ORDER BY net_realized_revenue DESC;


--Top 10 Customers
SET search_path TO ecom;
with cust_spend as (
select 
c.customer_id,c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(oi.line_total) as gross_realized_revenue 
FROM customers c join orders o 
ON o.customer_id=c.customer_id join
order_items oi on oi.order_id=o.order_id
--where c.country is not null
where lower(trim(o.status)) = 'delivered'
group by c.customer_id
--order by gross_realized_revenue DESC
),
refund_calculation AS (
    SELECT
    SUM(r.amount) AS refund_amount,c.customer_id
    FROM customers c JOIN orders o
    ON o.customer_id = c.customer_id
    JOIN refunds r
    ON r.order_id = o.order_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    AND LOWER(TRIM(r.status)) <> 'failed'
    GROUP BY c.customer_id
),
net_calculation as (
    select cs.customer_id,cs.CustomerName,cs.country,
    cs.gross_realized_revenue,
    COALESCE(rc.refund_amount,0) as refund_amount,
    cs.gross_realized_revenue-COALESCE(rc.refund_amount,0) as net_realized_revenue
    from cust_spend cs left join refund_calculation rc on 
    cs.customer_id=rc.customer_id
),
cust_ranking as (
select *,
dense_rank() over (ORDER BY net_realized_revenue desc) as cust_rank
from net_calculation
)
select cust_rank,CustomerName,customer_id,
CASE
    WHEN country IS NULL
         OR TRIM(country) = ''
         OR UPPER(TRIM(country)) IN ('N/A', 'NA', 'UNKNOWN')
    THEN 'Unknown / Not Provided'
    ELSE TRIM(country)
END AS country,
round(gross_realized_revenue,2) as gross_realized_revenue,
round(refund_amount,2) as total_refunds,
round(net_realized_revenue,2) as net_realized_revenue,
ROUND(refund_amount * 100 / NULLIF(gross_realized_revenue, 0),2) AS refund_rate_pct
from cust_ranking
WHERE cust_rank<=10



