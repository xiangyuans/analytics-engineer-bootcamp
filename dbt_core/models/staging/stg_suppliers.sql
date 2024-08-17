 {{
   config(
      materialized = 'table',
   )
}}

SELECT
    CAST(id AS INT) AS supplier_id,
    CAST(company AS STRING) AS company,
    CAST(last_name AS STRING) AS last_name,
    CAST(first_name AS STRING) AS first_name,
    CAST(email_address AS STRING) AS email_address,
    CAST(job_title AS STRING) AS job_title,
    CAST(business_phone AS STRING) AS business_phone,
    CAST(home_phone AS STRING) AS home_phone,
    CAST(mobile_phone AS STRING) AS mobile_phone,
    CAST(fax_number AS STRING) AS fax_number,
    CAST(address AS STRING) AS address,
    CAST(city AS STRING) AS city,
    CAST(state_province AS STRING) AS state_province,
    CAST(zip_postal_code AS STRING) AS zip_postal_code,
    CAST(country_region AS STRING) AS country_region,
    CAST(web_page AS STRING) AS web_page,
    CAST(notes AS STRING) AS notes,
    CAST(attachments AS STRING) AS attachments,
    CURRENT_TIMESTAMP() AS ingestion_timestamp
    
FROM {{ source ('northwind', 'suppliers')}} 