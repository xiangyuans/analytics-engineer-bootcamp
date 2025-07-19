 {{
   config(
      materialized = 'table'
   )
}}
SELECT *
FROM  {{ ref('stg_brand_items')}}