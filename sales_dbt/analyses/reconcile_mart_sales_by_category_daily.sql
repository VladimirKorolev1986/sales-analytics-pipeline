-- Ожидание:
--   only_in_old = 0              (ничего не потеряли)
--   only_in_new > 0              (новые категории: 'unknown' + португальские без перевода)
--   *_diff_rows = 0              (по общим строкам все метрики совпадают)
--   items_sold_diff = 1627       (1603 в 'unknown' + 24 в португальских)
WITH
    new as (
        SELECT * FROM {{ref('mart_sales_by_category_daily')}}
    ),
    old as (
        SELECT * FROM mart.sales_by_category_daily
    ),
    joined as (
        SELECT
            new.day as new_day,
            new.category as new_category,
            new.revenue as new_revenue,
            new.unique_products as new_unique_products,
            new.items_sold as new_items_sold,
            new.unique_orders as new_unique_orders,
            new.average_price as new_average_price,
            new.freight_revenue as new_freight_revenue,
            old.day as old_day,
            old.category as old_category,
            old.revenue as old_revenue,
            old.unique_products as old_unique_products,
            old.items_sold as old_items_sold,
            old.unique_orders as old_unique_orders,
            old.average_price as old_average_price,
            old.freight_revenue as old_freight_revenue
        FROM new full outer join old ON new.day = old.day and new.category = old.category
    )

SELECT
    count(*) filter (where old_day is null) as only_in_new,
    count(*) filter (where new_day  is null) as only_in_old,
    count(*) filter (where new_day is not null and old_day is not null and new_unique_products is distinct from old_unique_products) as unique_products_diff_days,
    count(*) filter (where new_day is not null and old_day is not null and new_revenue is distinct from old_revenue) as revenue_diff_days,
    count(*) filter (where new_day is not null and old_day is not null and new_items_sold is distinct from old_items_sold) as items_sold_diff_days,
    count(*) filter (where new_day is not null and old_day is not null and new_unique_orders is distinct from old_unique_orders) as unique_orders_diff_days,
    count(*) filter (where new_day is not null and old_day is not null and new_average_price is distinct from old_average_price) as average_price_diff_days,
    count(*) filter (where new_day is not null and old_day is not null and new_freight_revenue is distinct from old_freight_revenue) as freight_revenue_diff_days,
    sum(new_items_sold) - sum(old_items_sold) as items_sold_diff
FROM joined
