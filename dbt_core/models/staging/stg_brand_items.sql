 {{
   config(
      materialized = 'table'
   )
}}
-- brand item table with granularity on item level by brand
-- primary key is the brand_item_id
SELECT
  SAFE_CAST(_id.oid AS STRING) AS brand_item_id,
  SAFE_CAST(barcode AS STRING) AS item_barcode, -- CAST barcode to be string as barcode could start with 0
  SAFE_CAST(brandCode AS STRING) AS brand_code,
  SAFE_CAST(name AS STRING) AS brand_name,
  SAFE_CAST(categoryCode AS STRING) category_code,
  SAFE_CAST(category AS STRING) category
FROM {{ source ('fetch', 'brands')}}