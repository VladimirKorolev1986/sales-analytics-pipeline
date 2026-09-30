WITH source AS (

    SELECT * FROM {{ source('olist', 'olist_order_payments_dataset') }}

),
    renamed as (

         SELECT
             order_id,
             payment_sequential,
             payment_type,
             payment_installments,
             payment_value::numeric(10,2)
         FROM source
    )


SELECT * FROM renamed
