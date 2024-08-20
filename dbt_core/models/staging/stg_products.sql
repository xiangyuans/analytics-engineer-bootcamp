 {{
   config(
      materialized = 'table',
   )
}}

SELECT
   CAST(id AS INT) AS product_id,
   CAST(LEFT(supplier_ids,1) AS INT) AS supplier_id, -- get the first value as the supplier id for some data point
   CAST(product_code AS STRING) AS product_code,
   CAST(product_name AS STRING) AS product_name,
   CAST(description AS STRING) AS description,
   SAFE_CAST(standard_cost AS NUMERIC) AS standard_cost,
   SAFE_CAST(list_price AS NUMERIC) AS list_price,
   SAFE_CAST(reorder_level AS INT) AS reorder_level,
   SAFE_CAST(target_level AS INT) AS target_level,
   CAST(quantity_per_unit AS STRING) AS quantity_per_unit,
   SAFE_CAST(discontinued AS INT) AS discontinued, 
   SAFE_CAST(minimum_reorder_quantity AS INT) AS minimum_reorder_quantity,
   CAST(category AS STRING) AS category, 
   CAST(attachments AS STRING) AS attachments,
   CURRENT_TIMESTAMP() AS ingestion_timestamp

FROM {{ source ('northwind', 'products')}} 