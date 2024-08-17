 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS order_status_id,
   CAST(status_name AS STRING) AS status_name,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'orders_status')}} 