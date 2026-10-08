with sub as (
select order_id, order_item_id, count(*)
from {{ref('stg_olist__order_items')}}
group by order_id, order_item_id
having count(*) > 1
)

select order_id, order_item_id from sub
