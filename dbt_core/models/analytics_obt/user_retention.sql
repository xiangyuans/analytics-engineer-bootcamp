 {{
  config(
       materialized = 'incremental',
      unique_key=['user_id', 'firm_id', 'date'],
      partition_by={
        'field': 'date',
        'data_type': 'date'
        }
  )
}}



WITH yesterday AS (
    SELECT *
    FROM {{ this }}
    WHERE date = DATE('{{ var("target_date") }}')  - INTERVAL 1 DAY
 ),

today AS (
SELECT
    e.user_id,
    e.firm_id,
    created_date,
    COUNT(1)
FROM {{ ref('fact_event') }} e
WHERE DATE(created_date) = DATE('{{ var("target_date") }}')  
-- WHERE created_date =DATE('2024-04-04') 

GROUP BY 1,2,3
)

SELECT
    -- t.user_id,
    -- t.firm_id,
    -- t.created_date AS first_active_date,
    -- t.created_date AS last_active_date,
    COALESCE(t.user_id, y.user_id) AS user_id,
    COALESCE(t.firm_id, y.firm_id) AS firm_id,
    COALESCE(y.first_active_date, t.created_date) AS first_active_date,
    COALESCE(t.created_date, y.last_active_date) AS last_active_date,
    -- 'New' AS daily_active_state,
    -- 'New' AS weekly_active_state,
    -- t.created_date AS date
    CASE
        WHEN y.user_id IS NULL AND t.user_id IS NOT NULL THEN 'NEW'
        WHEN y.last_active_date = t.created_date - INTERVAL 1 DAY THEN 'Retained'
        WHEN y.last_active_date < t.created_date - INTERVAL 1 DAY THEN 'Resurrected'
        WHEN t.created_date IS NULL AND y.last_active_date = y.date THEN 'Churned'
        ELSE 'Stale'
    END AS daily_active_state,
     CASE
        WHEN y.user_id IS NULL AND t.user_id IS NOT NULL THEN 'NEW'
        WHEN y.last_active_date > t.created_date - INTERVAL 7 DAY THEN 'Retained'
        WHEN y.last_active_date < t.created_date - INTERVAL 7 DAY THEN 'Resurrected'
        WHEN t.created_date IS NULL AND y.last_active_date = y.date - INTERVAL 7 DAY THEN 'Churned'
        ELSE 'Stale'
    END AS weekly_active_state,
    COALESCE(t.created_date, DATE(y.date + INTERVAL 1 DAY)) AS date
FROM today t
FULL JOIN yesterday y
    ON t.user_id = y.user_id
    AND t.firm_id = y.firm_id