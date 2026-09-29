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
SELECT *
FROM view