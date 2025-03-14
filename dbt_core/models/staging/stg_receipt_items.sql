 {{
   config(
      materialized = 'table'
   )
}}
-- retrieve the items related info from the receipt
-- the granularity is on receipt item level
-- primary key is receipt item id
WITH update_data_types AS (
 SELECT
  SAFE_CAST(_id.oid AS STRING) AS receipt_id,
  SAFE_CAST(receipt_items.partnerItemId AS INT64) AS item_id,
  SAFE_CAST(receipt_items.brandCode AS STRING) AS brand_code,
  COALESCE(
    SAFE_CAST(receipt_items.barcode AS STRING),
    SAFE_CAST(receipt_items.userFlaggedBarcode AS STRING)) AS item_barcode,
  COALESCE(
    SAFE_CAST(receipt_items.originalReceiptItemText AS STRING), -- retrieve item info from three fields as item name.
    SAFE_CAST(receipt_items.description AS STRING),  -- ideally, originalReceiptItemText should be the item name.
    SAFE_CAST(receipt_items.userFlaggedDescription AS STRING)) AS item_name, -- using description as the secondary fields as it also contains valuable item info 
  COALESCE(
    SAFE_CAST(receipt_items.description AS STRING),  -- Retrieve item dscription from three fields.
    SAFE_CAST(receipt_items.userFlaggedDescription AS STRING), -- ideally description and userFlaggedDescription should contain item description
    SAFE_CAST(receipt_items.originalReceiptItemText AS STRING)) AS item_description, -- using originalReceiptItemText in case the first two fields are null
  COALESCE(
    SAFE_CAST(receipt_items.itemPrice AS FLOAT64), -- Use itemPrice and userFlaggedPrice as the item price
    SAFE_CAST(receipt_items.userFlaggedPrice AS FLOAT64)) AS item_price, -- ideally, itemPrice should be the item price. Use userFlaggedPrice when it is null
  COALESCE(
    SAFE_CAST(receipt_items.finalPrice AS FLOAT64), -- Use finalPrice and userFlaggedPrice as final price
    SAFE_CAST(receipt_items.userFlaggedPrice AS FLOAT64)) AS item_final_price, -- ideally, userFlaggedPrice should be the final item price. Use userFlaggedPrice when it is null
  COALESCE(
    SAFE_CAST(receipt_items.quantityPurchased AS INT64), -- Use quantityPurchased and userFlaggedQuantity as the total item quantity purchased for the receipt
    SAFE_CAST(receipt_items.userFlaggedQuantity AS INT64)) AS quantity, -- Only using userFlaggedQuantity when quantityPurchased is null
  SAFE_CAST(receipt_items.pointsEarned AS FLOAT64) AS points_earned,
  SAFE_CAST(receipt_items.deleted AS BOOLEAN) AS is_deleted
 FROM {{ source ('fetch', 'receipts')}} 
 CROSS JOIN UNNEST (`rewardsReceiptItemList`) AS receipt_items
),

-- count the number of line item 
-- for receipt under 'SUBMITTED' status, it does not contain valid info on receipt level
-- this is the pre step to assign item id (1) to SUBMITTED receipt
-- hence, it can be CONCAT with receipt_id and create a receipt item id using TO_HEX in the final SELECT statement
receipt_item_count AS (
SELECT
  receipt_id,
  COUNT(receipt_id) AS item_count
FROM update_data_types
GROUP BY 1
)

SELECT
  TO_HEX(SHA256(CONCAT(udt.receipt_id, CASE
                            WHEN udt.item_id IS NULL AND ric.item_count = 1 THEN 1
                            ELSE udt.item_id
                          END))) AS receipt_item_id,
  udt.receipt_id,
  CASE
    WHEN udt.item_id IS NULL AND ric.item_count = 1 THEN 1 -- assign item id (1) to receipt when the number of line item is 1
    ELSE udt.item_id
  END AS item_id,
  udt.brand_code,
  udt.item_barcode,
  udt.item_name,
  udt.item_description,
  udt.item_price,
  udt.item_final_price,
  quantity,
  points_earned,
  is_deleted
FROM update_data_types udt
JOIN receipt_item_count ric
  ON udt.receipt_id = ric.receipt_id