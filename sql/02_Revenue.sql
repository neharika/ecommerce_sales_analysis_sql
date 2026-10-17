

--Monthly Revenue from delivered orders
SET search_path TO ecom;
with revenue AS(
    SELECT  
    DATE_TRUNC('month',created_at) as y_month,
    MIN(created_at) AS first_order_date,
    MAX(created_at) AS last_order_date,
    sum(total) as monthly_revenue,
    count(*) as order_count,
    lower(trim(status)) as status1
    from orders
    where lower(trim(status)) like 'delivered'
    group by date_trunc('month',created_at),
    lower(trim(status))
    order by y_month asc
    ),
    prev_month as(
    select *,
    lag(monthly_revenue) over(order by y_month asc) as previous_month_revenue
    from revenue
    )
    SELECT
    to_char(y_month,'yyyy-mm') AS revenue_month,
    first_order_date,last_order_date,
    order_count,monthly_revenue,  
    round((monthly_revenue-previous_month_revenue)*100.0/previous_month_revenue,2) as grwth_pct,  
    ROUND(monthly_revenue / NULLIF(order_count, 0), 2) AS average_order_value,
    status1
    FROM prev_month 
    ORDER BY revenue_month;


--14-day Period sales and growth
--Since we have partial March and June months
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








