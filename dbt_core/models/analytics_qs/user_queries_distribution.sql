 {{
   config(
      materialized = 'table'
   )
}}

WITH user_total_queries AS (
  SELECT
    months,
    user_id,
    firm_id,
    query_type,
    engagement_level,
    SUM(query_counts) OVER (PARTITION BY user_id, firm_id) AS user_queries
  FROM {{ ref('monthly_user_engagement') }}
)

SELECT
  months,
  COUNT(DISTINCT user_id) AS user_ct,
  COUNT (DISTINCT CASE WHEN engagement_level = 'Average Engagement' THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS avg_engagement_ratio,
  COUNT (DISTINCT CASE WHEN engagement_level = 'Good Engagement' THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS good_engagement_ratio,
  COUNT (DISTINCT CASE WHEN engagement_level = 'High Engagement' THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS high_engagement_ratio,
  COUNT(DISTINCT CASE WHEN user_queries <= 4 THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS overall_low_engagement_ratio,
  COUNT(DISTINCT CASE WHEN user_queries > 4 AND user_queries <= 8 THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS overall_avg_engagement_ratio,
  COUNT(DISTINCT CASE WHEN user_queries > 8 AND user_queries <= 12 THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS overall_good_engagement_ratio,
  COUNT(DISTINCT CASE WHEN user_queries > 12 THEN user_id END) *1.0 / COUNT(DISTINCT user_id) AS overall_high_engagement_ratio

FROM user_total_queries 
GROUP BY 1


