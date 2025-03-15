 {{
   config(
      materialized = 'table'
   )
}}
-- dedup _id.oid: using distinct to remove duplicate _id.oid
SELECT DISTINCT
  SAFE_CAST(_id.oid AS STRING) AS user_id,
  SAFE_CAST(role AS STRING) AS role,
  SAFE_CAST(state AS STRING) AS state,
  SAFE_CAST(signUpSource AS STRING) AS signup_source,
  TIMESTAMP_MILLIS(SAFE_CAST(createdDate.date AS int64)) AS signup_date,
  TIMESTAMP_MILLIS(SAFE_CAST(lastLogin.date AS int64)) AS last_login_date,
  SAFE_CAST(active AS BOOLEAN) AS is_active
FROM {{ source ('fetch', 'users')}}