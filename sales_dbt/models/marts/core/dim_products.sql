WITH products AS (

    SELECT * FROM {{ ref('stg_olist__products') }}

    ),
    translations AS (

        SELECT * FROM {{ ref('stg_olist__category_translation') }}

    ),
    final AS (

        SELECT
          products.product_id,
          products.product_category_name,
          products.product_name_length,
          translations.product_category_name_english,
          products.product_description_length,
          products.product_photos_qty,
          products.product_weight_g,
          products.product_length_cm,
          products.product_height_cm,
          products.product_width_cm
        FROM products
        LEFT JOIN translations
        ON products.product_category_name=translations.product_category_name
    )

SELECT * FROM final