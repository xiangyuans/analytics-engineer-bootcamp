 {{
   config(
      materialized = 'table'
   )
}}

-- Retrieve user's firm id from event table
WITH event_users AS (
  SELECT
    firm_id,
    user_id,
    MAX(created_date) AS last_active_date
    FROM  {{ ref('stg_event')}}
    GROUP BY 1,2
)

SELECT
  u.user_id,
  eu.firm_id,
  u.created_date,
  u.user_title,
  eu.last_active_date
FROM  {{ref('stg_user')}} u
JOIN event_users eu
  ON u.user_id = eu.user_id