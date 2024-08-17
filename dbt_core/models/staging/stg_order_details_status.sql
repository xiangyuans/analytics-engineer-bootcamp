 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS order_details_status_id,
   CAST(status AS STRING) AS status,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'order_details_status')}} 