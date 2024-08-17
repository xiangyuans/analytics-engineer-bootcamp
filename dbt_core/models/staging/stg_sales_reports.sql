 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(group_by AS STRING) AS group_by,
   CAST(display AS STRING) AS display,
   CAST(title AS STRING) AS title,
   CAST(filter_row_source AS STRING) AS filter_row_source, 
   CAST(s.default AS STRING) AS defaults,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
   
FROM {{ source ('northwind', 'sales_reports')}} s