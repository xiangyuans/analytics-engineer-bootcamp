 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS order_id,
   CAST(employee_id AS INT) AS employee_id, 
   CAST(customer_id AS INT) AS customer_id,
   CAST(order_date AS TIMESTAMP) AS order_date,
   CAST(shipped_date AS TIMESTAMP) AS shipped_date,
   CAST(shipper_id AS INT) AS shipper_id,
   CAST(ship_name AS STRING) AS ship_name,
   CAST(ship_address AS STRING) AS ship_address,
   CAST(ship_city AS STRING) AS ship_city,
   CAST(ship_state_province AS STRING) AS ship_state_province,
   CAST(ship_zip_postal_code AS STRING) AS ship_zip_postal_code, 
   CAST(ship_country_region AS STRING) AS ship_country_region,
   CAST(shipping_fee AS NUMERIC) AS shipping_fee,
   CAST(taxes AS NUMERIC) AS taxes, 
   CAST(payment_type AS STRING) AS payment_type,
   CAST(paid_date AS TIMESTAMP) AS paid_date, 
   CAST(notes AS STRING) AS notes,
   CAST(tax_rate AS NUMERIC) AS tax_rate, 
   CAST(tax_status_id AS INT) AS tax_status_id,
   CAST(status_id AS INT) AS order_status_id,
   CURRENT_TIMESTAMP() AS ingestion_timestamp
FROM {{ source ('northwind', 'orders')}} 