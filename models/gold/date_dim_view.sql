{{ config({ "materialized":'view',
 "alias":'DATE_DIM_VIEW',
 "schema": 'GOLD'
})}}
 
WITH view AS(
SELECT
    ROW_NUMBER() OVER (ORDER BY DATE) AS DATE_ID
    ,DATE AS STORE_DATE
    ,ISHOLIDAY
    ,INSERT_DTS
    ,UPDATE_DTS
FROM {{ref('fact_snapshot')}}
GROUP BY
    DATE
)

SELECT *
FROM view v