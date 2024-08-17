 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS purchase_order_status_id,
   CAST(status AS STRING) AS purchase_order_status,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'purchase_order_status')}} 