
--Total No Of Orders (40,000)
SET search_path TO ecom;
select count(*) as Total_No_Orders
from orders;

SET search_path TO ecom;
select distinct status from orders;

--Total Revenue so far
SET search_path TO ecom;
with revenue_grouping as(
select lower(trim(status)) as status1,
sum(total) as revenue
from orders
group by lower(trim(status))
)
select 
sum(case when status1 ='delivered' 
then revenue else 0 END) as delivered_revenue,
sum(case when status1 in ('placed','packed','paid','shipped') 
then revenue else 0 end) as pipeline_revenue 
from 
revenue_grouping;



--Order State Distribution
SET search_path TO ecom;
with counting as (
select lower(trim(status)) as status1, 
count(lower(trim(status))) as count1,
sum(count(lower(trim(status)))) over () as order_count
 from orders
group by lower(trim(status))
)
select status1, count1,order_count,
    round(count1*100.0/order_count,2) as pct
    from counting;

SELECT
    payment_status,
    LOWER(TRIM(status)) AS status1,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*)::numeric
        / SUM(COUNT(*)) OVER () * 100,
        2
    ) AS pct_of_orders
FROM orders
GROUP BY
    payment_status,
    LOWER(TRIM(status))
ORDER BY
    order_count DESC;

--Status Discrepancy 
--(orders.status Vs order_status_history latest status-history record)
SET search_path TO ecom;
with ranked_history as (
    select order_id,
    lower(trim(status)) as history_status,
    changed_at,
    row_number() over (partition by order_id order by changed_at desc) as rn
    from order_status_history
),
ordering as (
    select order_id,history_status,changed_at
    from ranked_history
    where rn=1
)
select o1.order_id,o1.created_at,
o1.status as latest_status,
ord.history_status as latest_history_status,
ord.changed_at as latest_status_change,
case when lower(trim(o1.status))=ord.history_status
    then 'Match' else 'Mismatch' end as status_check
    from orders o1 join ordering ord on
    o1.order_id=ord.order_id
    where lower(trim(o1.status)) is distinct from ord.history_status
    order by o1.order_id;

--Status Discrepancy Timestamp check
--Check whether the latest history timestamp
--precedes the order creation timestamp
SET search_path TO ecom;
WITH latest_status AS (
    SELECT DISTINCT ON (order_id)
        order_id,
        status AS history_status,
        changed_at
    FROM order_status_history
    ORDER BY
        order_id,
        changed_at DESC
)
SELECT
    o.order_id,o.created_at,
    o.status AS orders_status,
    ls.history_status,
    ls.changed_at
FROM orders o
JOIN latest_status ls
    ON ls.order_id = o.order_id
WHERE LOWER(TRIM(o.status))
      IS DISTINCT FROM
      LOWER(TRIM(ls.history_status))
     and ls.changed_at < o.created_at 
ORDER BY o.order_id;