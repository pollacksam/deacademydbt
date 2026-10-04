{{ config({ "materialized":'view',
 "alias":'STORE_DIM_VIEW',
 "schema": 'GOLD'
})}}
 
WITH view AS(
SELECT
    STORE_ID AS STORE_ID
    ,DEPT_ID AS DEPT_ID
    ,INSERT_DTS
    ,UPDATE_DTS
FROM {{ref('transform_departments_load')}}
)

SELECT
    v.STORE_ID::INT AS STORE_ID
    ,v.DEPT_ID::INT AS DEPT_ID
    ,s.STORE_TYPE::VARCHAR(255) AS STORE_TYPE
    ,s.STORE_SIZE::INT AS STORE_SIZE
    ,v.INSERT_DTS::TIMESTAMP_NTZ(6) AS INSERT_DTS
    ,v.UPDATE_DTS::TIMESTAMP_NTZ(6) AS UPDATE_DTS
FROM view v
JOIN {{ref('transform_stores_load')}} s
    ON v.STORE_ID = s.STORE_ID
    AND v.DEPT_ID = s.DEPT_ID
ORDER BY
    STORE_ID, DEPT_ID