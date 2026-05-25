create table core.review_order_link as
select distinct review_id, 
				order_id 
from staging.olist_order_reviews_dataset