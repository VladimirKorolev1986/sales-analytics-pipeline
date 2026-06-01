CREATE SCHEMA IF NOT EXISTS mart;
DROP TABLE IF EXISTS mart.sales_daily;
CREATE TABLE mart.sales_daily AS
with orders_daily as (
	select 
	date(o.order_purchase_timestamp) as day,
	count(*) as orders_count,
	COUNT(*) FILTER (WHERE o.order_status = 'canceled') as canceled_count,
	count(distinct c.customer_unique_id) as unique_customers,
	round(avg(o.actual_delivery_time),2) as avg_delivery_time
	from core.orders o
	join core.customers c
	using(customer_id)
	group by 1
),
 payments_daily AS (
    SELECT date(o.order_purchase_timestamp) as day, SUM(p.payment_value) as revenue
    FROM core.orders o JOIN core.payments p USING(order_id)
    GROUP BY 1
  ),
	items_daily as (
	select date(o.order_purchase_timestamp) as day,
	count(*) as items_count
	FROM core.orders o JOIN core.order_items oi USING(order_id)
    GROUP BY 1

)

SELECT 
  o.day,
  o.orders_count,
  p.revenue,
  i.items_count,
  o.unique_customers,
  o.avg_delivery_time,
  ROUND(p.revenue / o.orders_count, 2) as avg_order_value,
  round((o.canceled_count::numeric*100/o.orders_count),2) as canceled_pct
FROM orders_daily o
LEFT JOIN payments_daily p USING(day)
LEFT JOIN items_daily i USING(day)
