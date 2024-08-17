 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS privilege_id,
   CAST(privilege_name AS STRING) AS privilege_name,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'privileges')}} 