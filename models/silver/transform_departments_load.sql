{{ config({ "materialized":'table',
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
)

SELECT *
FROM transform