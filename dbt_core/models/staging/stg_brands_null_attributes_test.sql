 {{
   config(
      materialized = 'table'
   )
}}
-- this is used to test if 3 attributes, including _id.oid, brand code, and topBrand
-- are having NOT NULL values
-- the result indicates that the users table passes NOT NULL test for attributes _id.oid
-- but brand code is null when the brand name is not null
-- also, for boolean attribute topBrand, many rows contain null values
WITH fail_count AS (
SELECT
  SUM(CASE
    WHEN _id.oid IS NULL
      OR (name IS NOT NULL AND brandCode IS NULL)
      OR topBrand IS NULL THEN 1 ELSE 0 END) AS counts,
  SUM(CASE WHEN _id.oid IS NULL THEN 1 ELSE 0 END) AS null_id_count,
  SUM(CASE WHEN name IS NOT NULL AND brandCode IS NULL THEN 1 ELSE 0 END) AS null_brandcode_count,
  SUM(CASE WHEN topBrand IS NULL THEN 1 ELSE 0 END) AS null_topbrand_flag_count
FROM {{ source ('fetch', 'brands')}}
  )

SELECT
  counts = 0 AS if_pass_tests,
  null_id_count = 0 AS if_pass_id_test,
  null_brandcode_count = 0 AS if_pass_brandcode_test,
  null_topbrand_flag_count = 0 AS if_pass_topbrand_flag_test
FROM fail_count

     

