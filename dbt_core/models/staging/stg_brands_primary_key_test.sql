 {{
   config(
      materialized = 'table'
   )
}}
-- it tests if the brands table passes the primaru key test
-- the result indicates that _id.oid is the primary key
-- it has unique _id.oid for each row
WITH id_count AS (
SELECT
  CAST(_id.oid AS STRING) AS brand_item_id,
  COUNT(_id.oid) AS brand_acounts
FROM {{ source ('fetch', 'brands')}}
GROUP BY 1)

SELECT
  MAX(brand_acounts) = 1 AS if_pass_uniqueness_test
FROM id_count
