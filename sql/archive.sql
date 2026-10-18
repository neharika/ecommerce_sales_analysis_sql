

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


