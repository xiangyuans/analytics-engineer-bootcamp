 {{
   config(
      materialized = 'table'
   )
}}

 SELECT
    CAST(FARM_FINGERPRINT(GENERATE_UUID()) AS INT64) AS event_id, -- use these functions to generate unique uuid as event id
    CAST(created AS DATE) AS created_date,
    CAST(firm_id AS STRING) AS firm_id,
    CAST(user_id AS STRING) AS user_id,
    CAST(event_type AS STRING) AS event_type,
    CAST(NUM_DOCS AS INT) AS num_docs,
    CAST(FEEDBACK_SCORE AS INT) AS feedback_score
FROM {{ source ('harvey', 'events')}}