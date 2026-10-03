with orders AS (

        SELECT * FROM {{ ref('stg_olist__orders') }}

),
    final AS (
        SELECT order_id,
               customer_id,
               order_status,
               order_purchase_timestamp,
               order_approved_at,
               order_delivered_carrier_date,
               order_delivered_customer_date,
               order_estimated_delivery_date,
               round(extract(EPOCH from (order_delivered_customer_date - order_purchase_timestamp))/86400, 2) as actual_delivery_time
        FROM orders
    )

SELECT * FROM final