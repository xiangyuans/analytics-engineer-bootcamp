 {{
   config(
      materialized = 'table'
   )
}}
-- this is used to test if in attribute role, each users has default value 'consumer'
-- the result indicates that the users table does not pass the test
-- in addition to 'consumer', some users have value other than 'consumer'
-- by querying SELECT DISTINCT role from {{ source ('fetch', 'users')}}
-- it inidicates that some users have role 'fetch-staff'
WITH fail_count AS (
  SELECT 
    SUM(CASE WHEN COALESCE(role, 'null') <> 'consumer' THEN 1 ELSE 0 END) AS counts
FROM {{ source ('fetch', 'users')}}
)

SELECT
  counts  = 0 AS if_pass_test
FROM fail_count