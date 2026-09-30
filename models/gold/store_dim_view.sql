{{ config({ "materialized":'view',
 "alias":'STORE_DIM_VIEW',
 "schema": 'GOLD'
})}}
 
WITH view AS(
SELECT
    STORE AS STORE_ID
    ,DEPT AS DEPT_ID
    ,INSERT_DTS
    ,UPDATE_DTS
FROM {{ref('transform_departments_load')}}
)

SELECT
    v.STORE_ID::INT AS STORE_ID
    ,v.DEPT_ID::INT AS DEPT_ID
    ,s.TYPE::VARCHAR(255) AS STORE_TYPE
    ,s.SIZE::INT AS STORE_SIZE
    ,v.INSERT_DTS::TIMESTAMP_NTZ(6) AS INSERT_DTS
    ,v.UPDATE_DTS::TIMESTAMP_NTZ(6) AS UPDATE_DTS
FROM view v
JOIN {{ref('transform_stores_load')}} s
    ON v.STORE_ID = s.STORE
ORDER BY
    STORE_ID, DEPT_ID