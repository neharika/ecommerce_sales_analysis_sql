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
FROM delivered_revenue,refund_calculation;


--Country Wise Revenue
SET search_path TO ecom;

WITH cust_demo AS (
SELECT 
     case 
    when lower(trim(c.country)) in ('','n/a','na') 
    or c.country is null
        then 'Not Available'
        else trim(c.country)
        end as country,
    SUM(oi.line_total) AS gross_revenue
    FROM customers c JOIN orders o
        ON o.customer_id = c.customer_id
    JOIN order_items oi
        ON oi.order_id = o.order_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    GROUP BY 1
),
refund_calculation AS (
    SELECT
       case 
        when lower(trim(c.country)) in ('','n/a','na') 
        or c.country is null
        then 'Not Available'
        else trim(c.country)
        end as country,
        SUM(r.amount) AS refund_amount
        FROM customers c JOIN orders o
        ON o.customer_id = c.customer_id
        JOIN refunds r
        ON r.order_id = o.order_id
        WHERE LOWER(TRIM(o.status)) = 'delivered'
        AND LOWER(TRIM(r.status)) <> 'failed'

    GROUP BY 1
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
