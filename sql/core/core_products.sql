create schema if not exists core;
drop table if exists core.products;

create table core.products as 
select opd.product_id, 
	opd.product_category_name, 
	opd.product_name_lenght as product_name_length,
	pcnt.product_category_name_english,
	opd.product_description_lenght as product_description_length, 
	opd.product_photos_qty,
	opd.product_weight_g,
	opd.product_length_cm, 
	opd.product_height_cm,
	opd.product_width_cm 
from staging.olist_products_dataset opd 
left join staging.product_category_name_translation pcnt on opd.product_category_name=pcnt.product_category_name
