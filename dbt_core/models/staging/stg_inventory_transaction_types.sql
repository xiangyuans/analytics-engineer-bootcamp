 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS transaction_type_id,
   CAST(type_name AS STRING) AS type_name,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'inventory_transaction_types')}} 