WITH orders AS (

    SELECT * FROM {{ ref('fct_orders') }}

),
    customers AS (

        SELECT * FROM {{ ref('stg_olist__customers') }}

    ),
    payments AS (

        SELECT * FROM {{ ref('stg_olist__order_payments') }}

    ),
    order_items AS (

        SELECT * FROM {{ ref('stg_olist__order_items') }}

    ),

    orders_daily AS (

        SELECT
            DATE(o.order_purchase_timestamp) as day,
            COUNT(*) as orders_count,
            COUNT(*) FILTER (WHERE o.order_status = 'canceled') as canceled_count,
            COUNT(DISTINCT c.customer_unique_id) as unique_customers,
            ROUND(avg(o.actual_delivery_time),2) as avg_delivery_time
        FROM orders o
        JOIN customers c
        USING (customer_id)
        GROUP BY 1
    ),
    payments_daily AS (
        SELECT
            DATE(o.order_purchase_timestamp) as day,
            SUM(p.payment_value) as revenue
        FROM orders o
        JOIN payments p
        USING(order_id)
        GROUP BY 1
    ),
    items_daily AS (
        SELECT
            DATE(o.order_purchase_timestamp) as day,
	        COUNT(*) as items_count
        FROM orders o
        JOIN order_items oi
        USING(order_id)
        GROUP BY 1
    ),
    final AS (
        SELECT
            o.day,
            o.orders_count,
            p.revenue,
            i.items_count,
            o.unique_customers,
            o.avg_delivery_time,
            ROUND(p.revenue / o.orders_count, 2) as avg_order_value,
            round((o.canceled_count::numeric*100/o.orders_count),2) as canceled_pct
        FROM orders_daily o
        LEFT JOIN payments_daily p USING(day)
        LEFT JOIN items_daily i USING(day)
    )



SELECT * FROM final
