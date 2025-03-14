 {{
   config(
      materialized = 'table'
   )
}}
-- brand table with granularity on brand
SELECT DISTINCT
  brandCode AS brand_code,
  name AS brand_name,
  topBrand AS is_top_brand
FROM {{ source ('fetch', 'brands')}}