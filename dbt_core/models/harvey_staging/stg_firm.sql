 {{
   config(
      materialized = 'table'
   )
}}

 SELECT
    CAST(ID AS STRING) AS firm_id,
    CAST(CREATED AS DATE) AS created_date,
    CAST(FIRM_SIZE AS INT) AS firm_size,
    CAST(ARR_IN_THOUSANDS AS INT) AS arr_in_thousands
FROM {{ source ('harvey', 'harvey_firms')}}