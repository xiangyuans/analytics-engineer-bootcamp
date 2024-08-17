 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS order_line_item_id,
   CAST(order_id AS INT) AS order_id,
   CAST(product_id AS INT) AS product_id,
   CAST(quantity AS INT) AS quantity,
   CAST(unit_price AS NUMERIC) AS unit_price,
   CAST(discount AS NUMERIC) AS discount,
   CAST(status_id AS INT) AS order_details_status_id,
   CAST(date_allocated AS TIMESTAMP) AS date_allocated,
   CAST(purchase_order_id AS INT) AS purchase_order_id, 
   CAST(inventory_id AS INT) AS inventory_id,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
   
FROM {{ source ('northwind', 'order_details')}} 