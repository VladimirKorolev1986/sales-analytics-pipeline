WITH source AS (

    SELECT * FROM {{ source('olist', 'olist_products_dataset') }}

),
    renamed AS (
        SELECT
          product_id,
          product_category_name,
          product_name_lenght::int as product_name_length,
          product_description_lenght::int as product_description_length,
          product_photos_qty::int,
          product_weight_g::numeric(10,2),
          product_length_cm::numeric(10,2),
          product_height_cm::numeric(10,2),
          product_width_cm::numeric(10,2)
        FROM source
    )

select * FROM renamed