{{ config({ "materialized":'incremental',
"incremental_strategy":'merge',
 "unique_key":['STORE_ID','DEPT_ID','STORE_DATE'],
 "transient":true,
 "alias":'DEPARTMENTS_TRANSFORM',
 "pre_hook": macros_copy_departments_csv('DEPARTMENTS_COPY'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT 
    STORE::INT AS STORE_ID
    ,DEPT::INT AS DEPT_ID
    ,DATE::DATE AS STORE_DATE
    ,WEEKLY_SALES::DECIMAL(20,2) AS STORE_WEEKLY_SALES
    ,ISHOLIDAY::VARCHAR(255) AS ISHOLIDAY
    ,INSERT_DTS::TIMESTAMP_NTZ(6) AS INSERT_DTS
    ,UPDATE_DTS::TIMESTAMP_NTZ(6) AS UPDATE_DTS
FROM {{source('source','DEPARTMENTS_COPY')}}

{% if is_incremental() %}
    where UPDATE_DTS > (select max(UPDATE_DTS) from {{this}})
    {% endif %}
)

SELECT *
FROM transform