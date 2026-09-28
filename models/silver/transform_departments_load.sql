{{ config({ "materialized":'table',
 "transient":true,
 "alias":'DEPARTMENTS_TRANSFORM',
 "pre_hook": macros_copy_departments_csv('DEPARTMENTS_COPY'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT 
    STORE AS STORE
    ,DEPT AS DEPT
    ,DATE AS DATE
    ,WEEKLY_SALES AS WEEKLY_SALES
    ,ISHOLIDAY AS ISHOLIDAY
    ,INSERT_DTS AS INSERT_DTS
    ,UPDATE_DTS AS UPDATE_DTS
FROM {{source('source','DEPARTMENTS_COPY')}}
)

SELECT *
FROM transform