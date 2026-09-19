--Monthly Revenue
SET search_path TO ecom;
with revenue AS(
    SELECT  
    to_char(date_trunc('month',created_at),'yyyy-mm') as y_month,
    sum(total) as MonthlyRevenue
    from orders
    where status not like 'cancelled'
    group by date_trunc('month',created_at)
    order by y_month asc
    ) ,
    prev_month as(
    select *,
    lag(MonthlyRevenue) over(order by y_month asc) as previous_Month_revenue
    from revenue
    )
    select * ,
    round((MonthlyRevenue-previous_Month_revenue)*100/previous_Month_revenue,2) as Mom_grwth_pct
    from prev_month

--Country Wise Revenue
SET search_path TO ecom;
with cust_demo as (
select 
--c.customer_id,c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(o.Total) as customer_spend 
FROM customers c join orders o 
ON o.customer_id=c.customer_id
--where c.country is not null
where o.status not like 'cancelled'
group by c.country
order by customer_spend DESC
)
select * from cust_demo


--Top 10 Customers
SET search_path TO ecom;
with cust_spend as (
select 
c.customer_id,c.first_name||' '||c.last_name as CustomerName,
c.country as country,
sum(o.Total) as customer_spend 
FROM customers c join orders o 
ON o.customer_id=c.customer_id
--where c.country is not null
where o.status not like 'cancelled'
group by c.customer_id
order by customer_spend DESC
),cust_ranking as (
select *,
dense_rank() over (ORDER BY customer_spend desc) as cust_rank
from cust_spend
)
select cust_rank,CustomerName,country,customer_spend,
customer_id from cust_ranking
WHERE cust_rank<=10
