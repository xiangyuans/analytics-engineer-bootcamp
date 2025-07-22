 {{
   config(
      materialized = 'table'
   )
}}

WITH user_monthly_query_types AS (
    SELECT
        months,
        user_id,
        firm_id,
        query_type,
        query_counts,
        engagement_level,
        COUNT(CASE WHEN query_counts > 0 THEN query_type END) OVER (PARTITION BY user_id, firm_id, months) AS query_type_ct
        FROM {{ ref('monthly_user_engagement') }}
    )

SELECT
  months,
  COUNT(DISTINCT user_id) AS user_ct,
  (COUNT(DISTINCT CASE WHEN query_type_ct = 3 THEN user_id END ) *1.0 / COUNT(DISTINCT user_id)) AS all_types_ratio,
  (COUNT(DISTINCT CASE WHEN query_type_ct = 2 THEN user_id END ) *1.0 / COUNT(DISTINCT user_id)) AS two_types_ratio,
  (COUNT(DISTINCT CASE WHEN query_type_ct = 1 THEN user_id END ) *1.0 / COUNT(DISTINCT user_id)) AS one_types_ratio
FROM user_monthly_query_types
GROUP BY 1

