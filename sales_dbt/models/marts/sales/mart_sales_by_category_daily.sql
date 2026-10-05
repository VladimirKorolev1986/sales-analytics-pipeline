WITH order_items AS (
    SELECT * FROM {{ ref('stg_olist__order_items') }}
),
    orders AS (
        SELECT * FROM {{ref('fct_orders')}}
    ),
    products AS (
        SELECT * FROM {{ref('dim_products')}}
    ),

    final AS (
        SELECT
            CAST(o.order_purchase_timestamp AS DATE) as day,
            COALESCE(p.product_category_name_english, p.product_category_name, 'unknown') as category,
            SUM(oi.price) as revenue,
            COUNT(DISTINCT oi.product_id) as unique_products,
            COUNT(oi.product_id) as items_sold,
            COUNT(DISTINCT o.order_id) as unique_orders,
            ROUND(AVG(oi.price), 2) as average_price,
            SUM(oi.freight_value) as freight_revenue
        FROM order_items oi
        LEFT JOIN orders o ON oi.order_id=o.order_id
        LEFT JOIN products p ON oi.product_id = p.product_id
        GROUP BY 1,2
    )


SELECT * FROM final