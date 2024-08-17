 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(string_id AS INT) AS string_id,
   CAST(string_data AS STRING) AS string_data,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'strings')}} 