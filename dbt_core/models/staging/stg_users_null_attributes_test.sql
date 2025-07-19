 {{
   config(
      materialized = 'table'
   )
}}
-- this is used to test if 5 attributes, including _id.oid, createdDate.date, role, lastLogin.date, active
-- are having NOT NULL values
-- the result indicates that the users table passes NOT NULL test for 4 attributes, but lastLogin.date
-- for many users, they do not have valid lastLogin.date
WITH fail_count AS (
SELECT
  SUM(CASE WHEN _id.oid IS NULL
          OR createdDate.date IS NULL
          OR role IS NULL
          OR lastLogin.date IS NULL
          OR active IS NULL
          THEN 1 END) AS counts,
  SUM(CASE WHEN _id.oid IS NULL THEN 1 ELSE 0 END) AS null_id_count,
  SUM(CASE WHEN createdDate.date IS NULL THEN 1 ELSE 0 END) AS null_date_count,
  SUM(CASE WHEN role IS NULL THEN 1 ELSE 0 END) AS null_role_count,
  SUM(CASE WHEN lastLogin.date IS NULL THEN 1 ELSE 0 END) AS null_last_login_count,
  SUM(CASE WHEN active IS NULL THEN 1 ELSE 0 END) AS null_active_count
FROM {{ source ('fetch', 'users')}}
)

SELECT
  counts = 0 AS if_pass_tests,
  null_id_count = 0 AS if_pass_id_test,
  null_date_count = 0 AS if_pass_date_test,
  null_role_count = 0 AS if_pass_role_date_test,
  null_last_login_count = 0 AS if_pass_last_login_test,
  null_active_count = 0 AS if_pass_active_test
FROM fail_count

