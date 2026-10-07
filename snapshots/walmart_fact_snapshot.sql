{% snapshot fact_snapshot %}
{{
    config(
      target_database='WALMART_DB',
      target_schema='snapshots',
      unique_key=['STORE_ID', 'DEPT_ID', 'DATE_ID'],
      strategy='check',
      check_cols=['STORE_SIZE', 'STORE_WEEKLY_SALES', 'FUEL_PRICE', 'STORE_TEMPERATURE', 'UNEMPLOYMENT',  'CPI',
      'MARKDOWN1', 'MARKDOWN2', 'MARKDOWN3', 'MARKDOWN4', 'MARKDOWN5'],
    )
}}
WITH source_data AS (
    SELECT
        d.STORE_ID
        ,d.DEPT_ID
        ,dt.DATE_ID
        ,s.STORE_SIZE
        ,d.STORE_WEEKLY_SALES
        ,f.FUEL_PRICE
        ,f.STORE_TEMPERATURE
        ,f.UNEMPLOYMENT
        ,f.CPI
        ,f.MARKDOWN1
        ,f.MARKDOWN2
        ,f.MARKDOWN3
        ,f.MARKDOWN4
        ,f.MARKDOWN5
    FROM
        {{ ref('transform_departments_load') }} d

    JOIN {{ ref('transform_fact_load') }} f
        ON d.STORE_ID = f.STORE_ID
        AND d.STORE_DATE = f.STORE_DATE

    JOIN {{ ref('walmart_date_dim') }} dt
        ON d.STORE_DATE = dt.STORE_DATE

    JOIN {{ ref('transform_stores_load') }} s
        ON d.STORE_ID = s.STORE_ID
)

SELECT
    source_data.STORE_ID
    ,source_data.DEPT_ID
    ,source_data.DATE_ID
    ,source_data.STORE_SIZE
    ,source_data.STORE_WEEKLY_SALES
    ,source_data.FUEL_PRICE
    ,source_data.STORE_TEMPERATURE
    ,source_data.UNEMPLOYMENT
    ,source_data.CPI
    ,source_data.MARKDOWN1
    ,source_data.MARKDOWN2
    ,source_data.MARKDOWN3
    ,source_data.MARKDOWN4
    ,source_data.MARKDOWN5
FROM source_data

{% endsnapshot %}