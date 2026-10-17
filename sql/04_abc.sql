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
