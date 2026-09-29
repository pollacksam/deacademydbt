{% snapshot fact_snapshot %}
{{
    config(
      target_database='WALMART_DB',
      target_schema='snapshots',
      unique_key=['STORE'],
      strategy='check',
      check_cols=['STORE', 'DATE', 'TEMPERATURE', 'FUEL_PRICE', 'MARKDOWN1', 'MARKDOWN2', 'MARKDOWN3', 'MARKDOWN4', 'MARKDOWN5'
                  'CPI', 'UNEMPLOYMENT', 'ISHOLIDAY'],
    )
}}
select * from {{ source('transform', 'FACT_TRANSFORM') }}
{% endsnapshot %}