{{ config({ "materialized":'view',
 "alias":'FACT_VIEW',
 "schema": 'GOLD'
})}}
 
WITH view AS(
SELECT
    STORE AS STORE_ID
    ,FUEL_PRICE
    ,TEMPERATURE AS STORE_TEMPERATURE
    ,UNEMPLOYMENT
    ,CPI
    ,MARKDOWN1
    ,MARKDOWN2
    ,MARKDOWN3
    ,MARKDOWN4
    ,MARKDOWN5
    ,INSERT_DTS
    ,UPDATE_DTS
    ,DBT_VALID_FROM AS VRSN_STRT_DTS
    ,COALESCE(DBT_VALID_TO , '9999-12-31 00:00:00.000') AS VRSN_END_DTS
FROM {{ref('fact_snapshot')}}
)

SELECT
    v.STORE_ID
    ,d.DEPT AS DEPT_ID
    ,d.WEEKLY_SALES AS STORE_WEEKLY_SALES
    ,v.FUEL_PRICE
    ,v.STORE_TEMPERATURE
    ,v.UNEMPLOYMENT
    ,v.CPI
    ,v.MARKDOWN1
    ,v.MARKDOWN2
    ,v.MARKDOWN3
    ,v.MARKDOWN4
    ,v.MARKDOWN5
    ,v.INSERT_DTS
    ,v.UPDATE_DTS
    ,v.VRSN_STRT_DTS
    ,v.VRSN_END_DTS
FROM view v
JOIN {{ref('transform_departments_load')}} d
    ON v.STORE_ID = d.STORE