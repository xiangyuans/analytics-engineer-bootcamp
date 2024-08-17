 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS invoice_id,
   CAST(order_id AS INT) AS order_id,
   CAST(invoice_date AS TIMESTAMP) AS invoice_date,
   CAST(due_date AS TIMESTAMP) AS due_date,
   CAST(tax AS NUMERIC) AS tax,
   CAST(shipping AS NUMERIC) AS shipping,
   CAST(amount_due AS NUMERIC) AS amount_due,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'invoices')}} 