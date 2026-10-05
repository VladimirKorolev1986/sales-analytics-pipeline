-- Сверка dbt-витрины со старой mart.sales_daily. Ожидание: все *_diff_days = 0; items_count_diff = 1627
-- старая версия выбрасывала позиции без категории через inner join
with
    new as (select * from {{ref('mart_sales_daily')}} ),
    old as (select * from mart.sales_daily),
    joined as (select
	  new.day as new_day,
	  new.orders_count as new_orders_count,
	  new.revenue as new_revenue,
	  new.unique_customers as new_unique_customers,
	  new.avg_delivery_time as new_avg_delivery_time,
	  new.avg_order_value as new_avg_order_value,
	  new.canceled_pct as new_canceled_pct,
	  new.items_count as new_items_count,
      old.day as old_day,
      old.orders_count as old_orders_count,
	  old.revenue as old_revenue,
	  old.unique_customers as old_unique_customers,
	  old.avg_delivery_time as old_avg_delivery_time,
	  old.avg_order_value as old_avg_order_value,
	  old.canceled_pct as old_canceled_pct,
	  old.items_count as old_items_count
    from new full outer join old on new.day = old.day)

select
    count(*) filter (where new_day is null or old_day is null) as missing_days,
    count(*) filter (where new_orders_count is distinct from old_orders_count) as orders_count_diff_days,
    count(*) filter (where new_revenue is distinct from old_revenue)  as revenue_diff_days,
    count(*) filter (where new_unique_customers is distinct from old_unique_customers)  as unique_customers_diff_days,
    count(*) filter (where new_avg_delivery_time is distinct from old_avg_delivery_time)  as avg_delivery_time_diff_days,
    count(*) filter (where new_avg_order_value is distinct from old_avg_order_value)  as   avg_order_value_diff_days,
    count(*) filter (where new_canceled_pct is distinct from old_canceled_pct)  as   canceled_pct_diff_days,
    sum(new_items_count) - sum(old_items_count) as items_count_diff
from joined