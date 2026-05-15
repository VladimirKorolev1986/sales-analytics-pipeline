CREATE SCHEMA IF NOT EXISTS core;
DROP TABLE IF EXISTS core.order_items;
CREATE TABLE core.order_items as 
select ooid.order_id, ooid.product_id, ooid.seller_id, opd.product_category_name, ooid.price, ooid.freight_value, pcnt.product_category_name_english
from staging.olist_order_items_dataset ooid
join staging.olist_products_dataset opd on ooid.product_id =opd.product_id 
join staging.product_category_name_translation pcnt on opd.product_category_name = pcnt.product_category_nam