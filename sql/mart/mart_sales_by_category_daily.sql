CREATE SCHEMA IF NOT EXISTS mart;
DROP TABLE IF EXISTS mart.sales_by_category_daily;
CREATE TABLE mart.sales_by_category_daily AS
SELECT cast(o.order_purchase_timestamp as DATE) as day, 
COALESCE(p.product_category_name_english, p.product_category_name, 'unknown') as category, 
round(sum(oi.price)::numeric,2) as revenue,
count(distinct oi.product_id) as unique_products,
count(oi.product_id) as items_sold,
COUNT(DISTINCT o.order_id) as unique_orders, 
round(avg(oi.price)::numeric,2) as average_price, 
round(sum(oi.freight_value)::numeric,2) as freight_revenue
FROM core.order_items oi
LEFT JOIN core.orders o on oi.order_id=o.order_id
LEFT JOIN core.products p on oi.product_id = p.product_id 
GROUP BY 1,2