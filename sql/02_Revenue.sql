

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













