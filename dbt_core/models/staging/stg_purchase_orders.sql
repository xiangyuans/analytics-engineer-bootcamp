 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS purchase_order_id,
   CAST(supplier_id AS INT) AS supplier_id, 
   CAST(created_by AS INT) AS created_by,
   CAST(submitted_date AS TIMESTAMP) AS submitted_date,
   CAST(creation_date AS TIMESTAMP) AS creation_date,
   CAST(status_id AS INT) AS purchase_order_status_id,
   CAST(expected_date AS TIMESTAMP) AS expected_date,
   CAST(shipping_fee AS NUMERIC) AS shipping_fee,
   CAST(taxes AS NUMERIC) AS taxes,
   CAST(payment_date AS TIMESTAMP) AS payment_date,
   CAST(payment_amount AS NUMERIC) AS payment_amount,
   CAST(payment_method AS STRING) AS payment_method,
   CAST(notes AS STRING) AS notes,
   CAST(approved_by AS INT) AS approved_by, 
   CAST(approved_date AS TIMESTAMP) AS approved_date,
   CAST(submitted_by AS INT) AS submitted_by,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
   
FROM {{ source ('northwind', 'purchase_orders')}} 