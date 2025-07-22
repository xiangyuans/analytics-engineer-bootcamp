 {{
   config(
      materialized = 'table'
   )
}}

SELECT
  firm_id,
  firm_size,
  arr_in_thousands,
  created_date
FROM  {{ref('stg_firm')}}