 {{
   config(
      materialized = 'table'
   )
}}

-- it tests if the receipts table passes the primaru key test
-- the result indicates that _id.oid is the primary key
-- it has unique _id.oid for each row
WITH id_count AS (
  SELECT
    CAST(_id.oid AS STRING) AS receipt_id,
    COUNT(_id.oid) AS receipt_count
  FROM {{ source ('fetch', 'receipts')}}
  GROUP BY 1)

  SELECT
    MAX(receipt_count) = 1 AS if_pass_uniqueness_test
  FROM id_count
