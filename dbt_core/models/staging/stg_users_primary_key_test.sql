 {{
   config(
      materialized = 'table'
   )
}}
-- the user table fails the primary key test. It has duplicate rows with the same values for each user based on _id.oid
WITH id_count AS (
SELECT
  CAST(_id.oid AS STRING) AS user_id,
  COUNT(_id.oid) AS user_acounts
FROM {{ source ('fetch', 'users')}}
GROUP BY 1)

SELECT
  MAX(user_acounts) = 1 AS if_pass_uniqueness_test
FROM id_count
