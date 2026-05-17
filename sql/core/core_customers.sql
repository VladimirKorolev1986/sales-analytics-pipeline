create schema if not exists core;
drop table if exists core.customers;

create table core.customers as 
select customer_id, 
	customer_unique_id, 
	customer_zip_code_prefix::varchar(16),
	customer_city, 
	customer_state
	from staging.olist_customers_dataset