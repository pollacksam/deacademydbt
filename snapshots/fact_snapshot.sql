{% snapshot fact_snapshot %}
{{
    config(
      target_database='WALMART_DB',
      target_schema='snapshots',
      unique_key='STORE_ID',
      strategy='check',
      check_cols=['STORE_ID', 'DEPT_ID', 'STORE_DATE', 'STORE_WEEKLY_SALES', 'FUEL_PRICE', 'STORE_TEMPERATURE', 'UNEMPLOYMENT',  'CPI',
      'MARKDOWN1', 'MARKDOWN2', 'MARKDOWN3', 'MARKDOWN4', 'MARKDOWN5'],
    )
}}
select * from {{ ref('transform_fact_load') }}
{% endsnapshot %}