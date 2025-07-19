 {{
   config(
      materialized = 'table'
   )
}}

SELECT *
FROM {{ ref('stg_receipt_items')}}