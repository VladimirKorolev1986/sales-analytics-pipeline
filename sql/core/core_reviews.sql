create schema if not exists core;
drop table if exists core.reviews;

create table core.reviews as
select distinct review_id, 
				review_score::smallint,
				review_comment_title,
				review_comment_message,
				review_creation_date::timestamp,
				review_answer_timestamp::timestamp
from staging.olist_order_reviews_dataset