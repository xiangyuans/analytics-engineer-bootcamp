 {{
   config(
      materialized = 'table'
   )
}}

WITH user_last_active_date AS (

    SELECT
        e.user_id,
        e.firm_id,
        event_type AS query_type,
        MIN(e.created_date) AS first_active_date,
        MAX(e.created_date) AS last_active_date
    FROM {{ ref('fact_event') }} e
    GROUP BY 1,2,3
    )


SELECT
    DATE_TRUNC(d.full_date, MONTH) AS months,
    ulad.user_id,
    ulad.firm_id,
    ulad.query_type,
    ulad.last_active_date,
    COUNT(e.event_id) AS query_counts,
    CASE
        WHEN COUNT(e.event_id) BETWEEN 1 AND 4 THEN 'Low Engagement'
        WHEN COUNT(e.event_id) BETWEEN 5 AND 8 THEN 'Average Engagement'
        WHEN COUNT(e.event_id) BETWEEN 9 AND 12 THEN 'Good Engagement'
        WHEN COUNT(e.event_id) > 12 THEN 'High Engagement'
        ELSE 'No Engagement'
    END AS engagement_level
    
FROM  {{ ref('dim_date') }} d  
CROSS JOIN user_last_active_date ulad
LEFT JOIN {{ ref('fact_event') }} e
    ON ulad.user_id = e.user_id
    AND ulad.firm_id = e.firm_id
    AND ulad.query_type = e.event_type
    AND d.full_date = e.created_date
WHERE ulad.last_active_date >= d.full_date
    AND ulad.first_active_date <= d.full_date
GROUP BY 1,2,3,4,5

