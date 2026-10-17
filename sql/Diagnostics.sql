SET search_path TO ecom;
    SELECT
        p.product_id,p.product_name,
        SUM(oi.line_total) AS gross_revenue,
        SUM(oi.qty) AS units_sold,
    --    sum(o.total)
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN product_variants pv
        ON pv.variant_id = oi.variant_id
    JOIN products p
        ON p.product_id = pv.product_id
 group by p.product_id


SET search_path TO ecom;
WITH item_totals AS (
    SELECT
        order_id,
        SUM(line_total) AS items_total
    FROM order_items
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.total AS order_total,
    COALESCE(it.items_total, 0) AS items_total,
    ROUND(
        o.total - COALESCE(it.items_total, 0),
        2
    ) AS difference
FROM orders o
LEFT JOIN item_totals it
    ON it.order_id = o.order_id
WHERE ABS(o.total - COALESCE(it.items_total, 0)) > 0.01
ORDER BY difference DESC
LIMIT 20;


SET search_path TO ecom;
SELECT
    order_id,
    subtotal,
    discount,
    tax,
    shipping_fee,
    total,
    ROUND(
        subtotal - COALESCE(discount, 0)
        + COALESCE(tax, 0)
        + COALESCE(shipping_fee, 0),
        2
    ) AS calculated_total,
    ROUND(
        total - (
            subtotal - COALESCE(discount, 0)
            + COALESCE(tax, 0)
            + COALESCE(shipping_fee, 0)
        ),
        2
    ) AS formula_difference
FROM orders
WHERE order_id = 33514;

SET search_path TO ecom;

SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE ABS(
            total - (
                subtotal
                - COALESCE(discount, 0)
                + COALESCE(tax, 0)
                + COALESCE(shipping_fee, 0)
            )
        ) < 0.01
    ) AS orders_matching_formula,
    COUNT(*) FILTER (
        WHERE ABS(
            total - (
                subtotal
                - COALESCE(discount, 0)
                + COALESCE(tax, 0)
                + COALESCE(shipping_fee, 0)
            )
        ) >= 0.01
    ) AS orders_not_matching_formula
FROM orders;



SET search_path TO ecom;

WITH item_revenue AS (
    SELECT
       order_id,
        SUM(line_total) AS item_revenue
    FROM order_items
    GROUP BY order_id
)
SELECT
    SUM(
        ir.item_revenue
        + COALESCE(o.tax, 0)
        + COALESCE(o.shipping_fee, 0)
    ) AS rev1,
    SUM(o.total) AS rev2
FROM orders o
JOIN item_revenue ir
  ON o.order_id = ir.order_id;


SET search_path TO ecom;

SELECT count (distinct order_id) 
from order_items

;
    SELECT distinct(order_id)
    FROM order_items
   limit 20;


--Top 10 Products by realized revenue
SET search_path TO ecom;
with Product_find as (
   select p.product_id,p.product_name,
   ri.qty,oi.unit_price,
   r.status as refund_status
   from products p join 
   product_variants pv
   on p.product_id=pv.product_id 
   join
   return_items ri on ri.variant_id=pv.variant_id 
   join
   return_requests rr on rr.return_id=ri.return_id 
   join
   order_items oi on oi.order_id=rr.order_id 
   AND oi.variant_id = ri.variant_id
   JOIN
   refunds r on r.order_id=oi.order_id
   --where 
   --group by p.product_id,ri.qty,oi.unit_price,r.status
)
select * from Product_find



SET search_path TO ecom;
SELECT
    COUNT(*) AS order_refund_rows,
    COUNT(DISTINCT order_id) AS order_refund_orders,
    SUM(refund_amount) AS order_refund_total
FROM order_refunds;


SET search_path TO ecom;
SELECT
    COUNT(*) AS refund_rows,
    COUNT(DISTINCT order_id) AS refund_orders,
    SUM(amount) AS refund_total
FROM refunds;


SET search_path TO ecom;
SELECT
    COUNT(DISTINCT o.order_id) AS matching_orders,
    SUM(o.refund_amount) AS order_refund_total,
    SUM(r.amount) AS refund_total
FROM order_refunds o
JOIN refunds r
    ON r.order_id = o.order_id;



SET search_path TO ecom;
SELECT
    LOWER(TRIM(o.status)) AS status,
    COUNT(DISTINCT r.order_id) AS refunded_orders,
    SUM(r.amount) AS refund_amount
FROM refunds r
JOIN orders o
    ON o.order_id = r.order_id
GROUP BY LOWER(TRIM(o.status))
ORDER BY refund_amount DESC;


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
select count(*) as refund_rows,
sum(amount) as total from refunds;
SELECT
    COUNT(*) AS refund_count,
    SUM(refund_amount) AS total_refund_amount
FROM order_refunds;



SET search_path TO ecom;
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


SET search_path TO ecom;
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'ecom'
  AND table_name IN (
      'products',
      'product_variants',
      'inventory_items',
      'order_items',
      'orders',
      'refunds',
      'return_items'
  )
ORDER BY table_name, ordinal_position;


SET search_path TO ecom;
SELECT
    p.product_id,
    p.product_name,
    SUM(ri.qty) AS returned_units,
    COUNT(DISTINCT rr.return_id) AS return_requests
FROM return_requests rr
JOIN return_items ri
    ON ri.return_id = rr.return_id
JOIN product_variants pv
    ON pv.variant_id = ri.variant_id
JOIN products p
    ON p.product_id = pv.product_id
WHERE LOWER(TRIM(rr.status)) = 'refunded'
GROUP BY
    p.product_id,
    p.product_name
ORDER BY returned_units DESC
LIMIT 10;


SET search_path TO ecom;
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.qty) AS units_sold
    FROM orders o
    JOIN order_items oi
        ON oi.order_id = o.order_id
    JOIN product_variants pv
        ON pv.variant_id = oi.variant_id
    JOIN products p
        ON p.product_id = pv.product_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    GROUP BY p.product_id, p.product_name
),
product_returns AS (
    SELECT
        pv.product_id,
        SUM(ri.qty) AS returned_units,
        COUNT(DISTINCT rr.return_id) AS return_requests
    FROM return_requests rr
    JOIN orders o
        ON o.order_id = rr.order_id
    JOIN return_items ri
        ON ri.return_id = rr.return_id
    JOIN product_variants pv
        ON pv.variant_id = ri.variant_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
      AND LOWER(TRIM(rr.status)) = 'refunded'
    GROUP BY pv.product_id
)

SELECT
    s.product_id,
    s.product_name,
    s.units_sold,
    COALESCE(r.returned_units, 0) AS returned_units,
    COALESCE(r.return_requests, 0) AS return_requests,
    ROUND(
        COALESCE(r.returned_units, 0) * 100.0
        / NULLIF(s.units_sold, 0),
        2
    ) AS return_rate_pct
FROM product_sales s
LEFT JOIN product_returns r
    ON s.product_id = r.product_id
    where s.units_sold>10
ORDER BY return_rate_pct DESC, returned_units DESC;


SET search_path TO ecom;
select * from order_items
where line_discount=0

SET search_path TO ecom;
SELECT
    LOWER(TRIM(o.status)) AS order_status,
    LOWER(TRIM(r.status)) AS refund_status,
    COUNT(*) AS refund_records,
    ROUND(SUM(r.amount), 2) AS refund_amount
FROM refunds r
JOIN orders o
    ON o.order_id = r.order_id
GROUP BY
    LOWER(TRIM(o.status)),
    LOWER(TRIM(r.status))
ORDER BY
    order_status,
    refund_status;


SET search_path TO ecom;
select oi.order_id,oi.variant_id,oi.unit_price,
oi.qty as ordered_qty, ri.return_id,
ri.qty as returned_qty,pv.product_id ,
p.product_name
from order_items oi 
left join
return_items ri on oi.variant_id=ri.variant_id
join product_variants pv on ri.variant_id=pv.variant_id
join refunds r on r.order_id=oi.order_id
join products p on p.product_id=pv.product_id 
order by oi.order_id asc
limit 20


SET search_path TO ecom;
select * from product_variants
where variant_id in (1198,4903,2529,128)



SET search_path TO ecom;
select * from order_status_history orh join
orders o on o.order_id=orh.order_id
limit 50



SET search_path TO ecom;
with ranked_history as (
    select order_id,
    lower(trim(status)) as history_status,
    changed_at,
    row_number() over (partition by order_id order by changed_at desc) as rn
    from order_status_history
),
--select * from ranked_history
ordering as (
    select order_id,history_status,changed_at
    from ranked_history
    where rn=1
)
select o1.order_id,
o1.status as latest_status,
ord.history_status as latest_history_status,
ord.changed_at as latest_status_change,
case when lower(trim(o1.status))=ord.history_status
    then 'Match' else 'Mismatch' end as status_check
    from orders o1 join ordering ord on
    o1.order_id=ord.order_id
    where lower(trim(o1.status)) is distinct from ord.history_status
    order by o1.order_id



SET search_path TO ecom;
select * from orders
--where order_id=25543
where lower(trim(status))= 'cancelled'

SET search_path TO ecom;
select * from order_status_history
where order_id=25543


SELECT
    rr.return_id,
    rr.order_id,
    rr.status AS return_status,
    ri.variant_id AS returned_variant_id,
    p.product_name AS returned_product,
    oi.variant_id AS purchased_variant_id,
    p2.product_name AS purchased_product
FROM return_requests rr
JOIN return_items ri
    ON ri.return_id = rr.return_id
JOIN product_variants pv
    ON pv.variant_id = ri.variant_id
JOIN products p
    ON p.product_id = pv.product_id
LEFT JOIN order_items oi
    ON oi.order_id = rr.order_id
LEFT JOIN product_variants pv2
    ON pv2.variant_id = oi.variant_id
LEFT JOIN products p2
    ON p2.product_id = pv2.product_id
WHERE rr.return_id IN (1, 2, 3, 4, 5)
ORDER BY rr.return_id, oi.variant_id;


SET search_path TO ecom;
with find_orders as (
    select created_at, status, total,
    ntile(4) over ( order by  created_at) as bin
    --date_trunc('month',created_at) as 
    from orders
    where lower(trim(status)) ='delivered'
)
    select bin,min(created_at) as first_order,
    max(created_at) as last_order,
    count(*) as order_count,
    sum(total) as revenue from find_orders
    group by bin
    order by bin


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