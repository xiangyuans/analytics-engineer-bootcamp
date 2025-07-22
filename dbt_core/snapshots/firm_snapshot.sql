-- snapshots/firm_snapshot.sql
{% snapshot firm_snapshot %}
    {{
        config(
            target_schema='snapshots',
            unique_key='firm_id',
            strategy='check',
            check_cols=['firm_size', 'arr_in_thousands'],
            dbt_valid_from ='created_date'
        )
    }}
    SELECT
        firm_id,
        firm_size,
        arr_in_thousands,
        CAST(created_date AS TIMESTAMP) AS created_date
    FROM {{ ref('stg_firm') }}
{% endsnapshot %}
