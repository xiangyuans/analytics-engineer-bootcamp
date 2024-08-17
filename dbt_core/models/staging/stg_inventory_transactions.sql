 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS inventory_transaction_id,
   CAST(transaction_type AS STRING) AS transaction_type,
   CAST(transaction_created_date AS TIMESTAMP) AS transaction_created_date,
   CAST(transaction_modified_date AS TIMESTAMP) AS transaction_modified_date,
   CAST(product_id AS INT) AS product_id,
   CAST(quantity AS INT) AS quantity,
   CAST(purchase_order_id AS INT) AS purchase_order_id,
   CAST(customer_order_id AS INT) AS customer_order_id,
   CAST(comments AS STRING) AS comments,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'inventory_transactions')}} 