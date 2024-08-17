 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS purchase_line_item_id,
   CAST(purchase_order_id AS INT) AS purchase_order_id,
   CAST(product_id AS INT) AS product_id,
   CAST(quantity AS INT) AS quantity,
   CAST(unit_cost AS NUMERIC) AS unit_cost,
   CAST(date_received AS TIMESTAMP) AS date_received,
   CAST(posted_to_inventory AS INT) AS posted_to_inventory,
   CAST(inventory_id AS INT) AS inventory_id,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'purchase_order_details')}} 