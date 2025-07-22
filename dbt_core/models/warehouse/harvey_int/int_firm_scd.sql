 {{
   config(
      materialized = 'table'
   )
}}

-- use this table to track all slowly changes on firm size and arr for each firm

WITH rank_records AS (
SELECT
    firm_id,
    firm_size,
    arr_in_thousands,
    created_date,
    dbt_scd_id,
    dbt_updated_at,
    dbt_valid_from,
    dbt_valid_to,
    ROW_NUMBER() OVER (PARTITION BY firm_id ORDER BY dbt_valid_from) AS rn -- rank all records for each firm
FROM {{ ref('firm_snapshot') }}
)

SELECT
    firm_id,
    firm_size,
    arr_in_thousands,
    created_date,
    dbt_scd_id,
    dbt_updated_at,
    -- modified valid from for first record
    -- from the first snapshot run date to firm created date
    -- assuming that firm size and arr remain the same since created at harvey
    CASE 
        WHEN rn = 1 THEN CAST(created_date AS TIMESTAMP)
        ELSE dbt_valid_from
    END AS dbt_valid_from,
    dbt_valid_to
FROM rank_records