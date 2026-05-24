create schema if not exists core;
drop table if exists core.payments;

create table core.payments as 

select order_id,
		payment_sequential,
		payment_type,
		payment_installments,
		payment_value::numeric(10,2)
from staging.olist_order_payments_dataset oopd 