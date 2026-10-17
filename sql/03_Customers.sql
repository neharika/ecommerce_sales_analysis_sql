
--Total No of Customers (10,000)
SET search_path TO ecom;
select count(distinct customer_id)
from customers;


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
