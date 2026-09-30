{{ config({ "materialized":'view',
 "alias":'DATE_DIM_VIEW',
 "schema": 'GOLD'
})}}
 
WITH view AS(
SELECT
    DENSE_RANK() OVER (ORDER BY DATE) AS DATE_ID
    ,DATE AS STORE_DATE
    ,ISHOLIDAY
    ,INSERT_DTS
    ,UPDATE_DTS
FROM {{ref('fact_snapshot')}}
)

SELECT *
FROM view v
GROUP BY
    DATE_ID, STORE_DATE, ISHOLIDAY, INSERT_DTS, UPDATE_DTS