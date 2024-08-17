 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(employee_id AS INT) AS employee_id,
   CAST(privilege_id AS INT) AS privilege_id,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'employee_privileges')}} 