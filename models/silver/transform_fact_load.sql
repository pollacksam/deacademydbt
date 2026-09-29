{{ config({ "materialized":'table',
 "transient":true,
 "alias":'FACT_TRANSFORM',
 "pre_hook": macros_copy_fact_csv('FACT_COPY'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT 
    STORE AS STORE
    ,DATE AS DATE
    ,TEMPERATURE AS TEMPERATURE
    ,FUEL_PRICE AS FUEL_PRICE
    ,MARKDOWN1 AS MARKDOWN1
    ,MARKDOWN2 AS MARKDOWN2
    ,MARKDOWN3 AS MARKDOWN3
    ,MARKDOWN4 AS MARKDOWN4
    ,MARKDOWN5 AS MARKDOWN5 
    ,CPI AS CPI
    ,UNEMPLOYMENT AS UNEMPLOYMENT
    ,ISHOLIDAY AS ISHOLIDAY
    ,INSERT_DTS AS INSERT_DTS
    ,UPDATE_DTS AS UPDATE_DTS
FROM {{source('source','FACT_COPY')}}
)

SELECT *
FROM transform