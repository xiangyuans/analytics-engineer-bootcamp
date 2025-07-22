 {{
   config(
      materialized = 'table'
   )
}}

SELECT
  event_id,
  firm_id,
  user_id,
  event_type,
  num_docs,
  feedback_score,
  created_date
FROM  {{ref('stg_event')}}