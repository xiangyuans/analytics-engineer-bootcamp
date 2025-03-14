 {{
   config(
      materialized = 'table'
   )
}}
--retrieve order level attributes, including id, user_id, total item quantity, spend, purchased date, scanned date
--event finished date, rewards status, total points earned, bonus points, and points awarded date for the receipt
--primary key for receipt_id on the receipt/order level
SELECT
  SAFE_CAST(_id.oid AS STRING) AS receipt_id,
  SAFE_CAST(userId AS STRING) AS user_id,
  SAFE_CAST(purchasedItemCount AS INT64) AS quantity,
  SAFE_CAST(totalSpent AS FLOAT64) AS total_spent,
  TIMESTAMP_MILLIS(SAFE_CAST(purchaseDate.date AS INT64)) AS purchase_date,
  TIMESTAMP_MILLIS(SAFE_CAST(dateScanned.date AS INT64)) AS date_scanned,
  TIMESTAMP_MILLIS(SAFE_CAST(finishedDate.date AS INT64)) AS finished_date,
  SAFE_CAST(rewardsReceiptStatus AS STRING) AS rewards_status,
  SAFE_CAST(pointsEarned AS FLOAT64) AS point_earned,
  SAFE_CAST(bonusPointsEarned AS FLOAT64) AS bonus_points_earned,
  SAFE_CAST(bonusPointsEarnedReason AS STRING) AS bonus_point_reason,
  TIMESTAMP_MILLIS(SAFE_CAST(pointsAwardedDate.date AS INT64)) AS points_awarded_date
FROM {{ source ('fetch', 'receipts')}} 