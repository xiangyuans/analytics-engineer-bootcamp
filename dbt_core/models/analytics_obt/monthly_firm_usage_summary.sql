 {{
   config(
      materialized = 'table'
   )
}}

    SELECT
        DATE_TRUNC(d.full_date, MONTH) AS months,
        f.firm_id,
        ROUND(AVG(f.firm_size), 0) AS firm_size,
        ROUND(AVG(f.arr_in_thousands),0) AS arr_in_thousand,
        COUNT(DISTINCT e.user_id) AS active_users,
        COUNT(e.event_id) AS total_queries,
        ROUND(COUNT(e.event_id)*1.0/AVG(f.firm_size),0) AS queries_per_user,
        ROUND(COUNT(DISTINCT e.user_id) * 1.0 / AVG(f.firm_size), 3) AS adoption_rate
    FROM {{ ref('dim_date') }} d
    CROSS JOIN {{ ref('int_firm_scd') }} f
    LEFT JOIN {{ ref('fact_event') }} e
        ON f.firm_id = e.firm_id
        AND e.created_date BETWEEN DATE(f.dbt_valid_from) AND COALESCE(DATE(f.dbt_valid_to), DATE('2999-12-31'))
    WHERE f.created_date <= d.full_date
        AND CURRENT_DATE >= d.full_date
        AND d.full_date BETWEEN DATE(f.dbt_valid_from) AND COALESCE(DATE(f.dbt_valid_to), DATE('2999-12-31'))
    GROUP BY 1,2