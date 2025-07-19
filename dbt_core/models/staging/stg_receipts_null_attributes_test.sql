 {{
   config(
      materialized = 'table'
   )
}}
-- this is used to test if 14 attributes, including receipt level attributes:
-- _id.oid, userId , and rewardsReceiptStatus, purchasedItemCount, totalSpent, dateScanned.date, finishedDate.date
-- purchaseDate.date, pointsAwardedDate.date, and point earned:COALESCE(r.pointsEarned,0) + COALESCE(r.bonusPointsEarned,0)
-- and receipt item level attributes:
-- barcode, quantityPurchased OR userFlaggedQuantity (item quantity), finalPrice OR userFlaggedPrice OR itemPrice (item price)
-- are having NOT NULL values
-- the result indicates that the receipts table DOES NOT passes NOT NULL test for attributes:
-- purchasedItemCount, barcode, item quantity, item price
-- the purchasedItemCount is NULL for some receipts
-- item brandCode is null when ther is a brandcode or the rewardsReceiptStatus = 'FINISHED' 
-- similar to item quantity and item price, NULL value presents when rewardsReceiptStatus = 'FINISHED'

WITH fail_count AS (
  SELECT
    SUM( -- receipt level null attributes
          CASE WHEN _id.oid IS NULL
            OR userId IS NULL
            OR rewardsReceiptStatus IS NULL
            OR purchasedItemCount IS NULL
            OR totalSpent IS NULL
            OR dateScanned.date IS NULL
            OR (rewardsReceiptStatus = 'FINISHED' AND finishedDate.date IS NULL) -- null finished date
            OR (rewardsReceiptStatus = 'FINISHED' AND purchaseDate.date IS NULL) -- null purchased date 
            OR (rewardsReceiptStatus = 'FINISHED' AND COALESCE(r.pointsEarned,0) + COALESCE(r.bonusPointsEarned,0) > 0 
                AND pointsAwardedDate.date IS NULL) -- null awarded date
            OR (rewardsReceiptStatus = 'FINISHED' AND pointsAwardedDate.date IS NOT NULL
              AND COALESCE(r.pointsEarned,0) + COALESCE(r.bonusPointsEarned,0) = 0 ) -- null rewards points
        -- receipt item level null atrributes
            OR (receipt_items.brandCode IS NOT NULL AND receipt_items.barcode IS NULL) -- null item bracode belong to a brand
            OR (rewardsReceiptStatus = 'FINISHED' AND receipt_items.barcode IS NULL) -- null item barcode for finished receipt
            OR (rewardsReceiptStatus = 'FINISHED' AND receipt_items.quantityPurchased IS NULL
                AND receipt_items.userFlaggedQuantity IS NULL) -- null item quantity for finished receiptt
            OR (rewardsReceiptStatus = 'FINISHED' AND receipt_items.finalPrice IS NULL
                AND receipt_items.userFlaggedPrice IS NULL AND receipt_items.itemPrice IS NULL) -- finished receiptt item price
            THEN 1 ELSE 0 END) AS counts,
    
    -- receipt level null attributes
    SUM(CASE WHEN _id.oid IS NULL THEN 1 ELSE 0 END) AS null_id_count,
    SUM(CASE WHEN userId IS NULL THEN 1 ELSE 0 END) AS null_user_id_count,
    SUM(CASE WHEN rewardsReceiptStatus IS NULL THEN 1 ELSE 0 END) AS null_rewards_status_count,
    SUM(CASE WHEN purchasedItemCount IS NULL THEN 1 ELSE 0 END) AS null_receipt_quantity_count,
    SUM(CASE WHEN totalSpent IS NULL THEN 1 ELSE 0 END) AS null_receipt_spent_count,
    SUM(CASE WHEN dateScanned.date IS NULL THEN 1 ELSE 0 END) AS null_scanned_date_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND finishedDate.date IS NULL THEN 1 ELSE 0 END) AS null_finished_date_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' and purchaseDate.date IS NULL THEN 1 ELSE 0 END) AS null_purchased_date_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND COALESCE(r.pointsEarned,0) + COALESCE(r.bonusPointsEarned,0) > 0 
                AND pointsAwardedDate.date IS NULL THEN 1 ELSE 0 END) AS null_awarded_date_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND pointsAwardedDate.date IS NOT NULL
              AND COALESCE(r.pointsEarned,0) + COALESCE(r.bonusPointsEarned,0) = 0 THEN 1 ELSE 0 END) AS null_reward_point_count,
    
    -- receipt item level null attributes
    SUM (CASE WHEN receipt_items.brandCode IS NOT NULL AND receipt_items.barcode IS NULL THEN 1 ELSE 0 END) AS null_brand_barcode_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND receipt_items.barcode IS NULL THEN 1 ELSE 0 END) AS null_barcode_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND receipt_items.quantityPurchased IS NULL
                AND receipt_items.userFlaggedQuantity IS NULL THEN 1 ELSE 0 END) AS null_item_quantity_count,
    SUM(CASE WHEN rewardsReceiptStatus = 'FINISHED' AND receipt_items.finalPrice IS NULL
                AND receipt_items.userFlaggedPrice IS NULL AND receipt_items.itemPrice IS NULL THEN 1 ELSE 0 END) AS null_item_price_count
  FROM {{ source ('fetch', 'receipts')}} r
  CROSS JOIN UNNEST (`rewardsReceiptItemList`) AS receipt_items
)

  SELECT
    counts = 0 AS if_pass_tests,
    null_id_count = 0 AS if_pass_id_test,
    null_user_id_count = 0 AS if_pass_user_id_test,
    null_rewards_status_count = 0 AS if_pass_rewards_status_test,
    null_receipt_quantity_count = 0 AS if_pass_receipt_quantity_test,
    null_receipt_spent_count = 0 AS if_pass_receipt_spent_test,
    null_scanned_date_count = 0 AS if_pass_scanned_date_test,
    null_purchased_date_count = 0 AS if_pass_purchased_date_test,
    null_brand_barcode_count = 0 AS if_pass_brand_barcode_test,
    null_finished_date_count = 0 AS if_pass_finish_date_test,
    null_awarded_date_count = 0 AS if_pass_awarded_date_test,
    null_reward_point_count = 0 AS if_pass_report_point_test,
    null_barcode_count = 0 AS if_pass_barcode_test,
    null_item_quantity_count = 0 AS if_pass_item_quantity_test,
    null_item_price_count = 0 AS if_pass_item_price_test
  FROM fail_count

     

