 {{
   config(
      materialized = 'table'
   )
}}

 SELECT
    CAST(ID AS STRING) AS user_id,
    CAST(CREATED AS DATE) AS created_date,
    CAST(TITLE AS STRING) AS user_title
FROM {{ source ('harvey', 'harvey_users')}}