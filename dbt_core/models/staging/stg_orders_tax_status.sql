 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS tax_status_id,
   CAST(tax_status_name AS STRING) AS tax_status_name,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'orders_tax_status')}} 