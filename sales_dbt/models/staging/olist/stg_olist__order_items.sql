WITH source AS (

    SELECT * FROM {{ source('olist', 'olist_order_items_dataset') }}

),
    renamed AS (
        SELECT
            order_id,
            order_item_id,
            product_id,
            seller_id,
            shipping_limit_date::timestamp,
            price::NUMERIC(10,2),
            freight_value::NUMERIC(10,2)
        FROM source
    )

SELECT * FROM renamed