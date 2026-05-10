CREATE SCHEMA IF NOT EXISTS core;
drop table if exists core.orders;
create table core.orders as 
select order_id, 
	   customer_id, 
	   order_status, 
	   order_purchase_timestamp::timestamp, 
	   order_approved_at::timestamp, 
	   order_delivered_carrier_date::timestamp,
	   order_delivered_customer_date::timestamp,
	   order_estimated_delivery_date::timestamp,
	   round(extract(EPOCH from (order_delivered_customer_date::timestamp - order_purchase_timestamp::timestamp))/86400, 2) as actual_delivery_time
from staging.olist_orders_dataset
