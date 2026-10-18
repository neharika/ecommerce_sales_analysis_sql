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
limit 10;



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
limit 10;

