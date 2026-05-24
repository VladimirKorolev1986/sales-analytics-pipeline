create schema if not exists core;
drop table if exists core.sellers;

create table core.sellers as 
select seller_id,
		seller_zip_code_prefix::varchar(16),
		seller_city,
		seller_state
from staging.olist_sellers_dataset osd;