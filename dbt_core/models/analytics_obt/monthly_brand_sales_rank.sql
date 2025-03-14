 {{
   config(
      materialized = 'table'
   )
}}
-- this table demonstrates the brand rank by sales (items final prices from each receipts) by scanned month
-- by using brand_sales_rank, it can be filtered to top N brands over time. for example,
-- as stakeholder is interested in the top 5 brand, use brand_sales_rank <= 5 in the where clause
-- is_current_month and brand_sales_rank <= 5 can be used together to pull the top 5 brand in the most recent month
-- as well as the top 5 brands for the previous month

WITH sales_by_brand AS (
  SELECT
    DATE_TRUNC(fr.date_scanned, MONTH) AS scanned_month,
    fri.brand_code AS brand_code,
    db.brand_name,
    ROUND(SUM(COALESCE(item_final_price,item_price)),2) AS sales, -- in case the final price is null, using the item_price as the secondary value
    SUM(fri.quantity) AS quantity

  FROM {{ ref('fact_receipt_items')}} fri
  JOIN {{ ref('stg_receipts')}} fr 
    ON fri.receipt_id = fr.receipt_id
  LEFT JOIN {{ ref('dim_brands')}} db
    ON fri.brand_code = db.brand_code
  GROUP BY 1,2,3
),

brand_rank AS (
  SELECT
    scanned_month,
    brand_code,
    brand_name,
    sales,
    quantity,
    DENSE_RANK() OVER (PARTITION BY scanned_month ORDER BY sales DESC) AS brand_sales_rank,
    ROW_NUMBER() OVER (PARTITION BY scanned_month ORDER BY sales DESC) AS brand_number
  FROM sales_by_brand
  WHERE brand_code IS NOT NULL
)

SELECT
  scanned_month,
  brand_code,
  sales,
  quantity,
  brand_sales_rank,
  LAG(brand_code, 1) OVER (PARTITION BY brand_number ORDER BY scanned_month) AS pre_month_brand,
  LAG(sales, 1) OVER (PARTITION BY brand_number ORDER BY scanned_month) AS pre_month_brand_sales,
  CASE
    WHEN DATE_TRUNC(CURRENT_TIMESTAMP(), MONTH) = scanned_month THEN TRUE
    ELSE FALSE
  END AS is_current_month
FROM brand_rank
-- WHERE brand_sales_rank <= 5 
-- ORDER BY scanned_month, brand_sales_rank