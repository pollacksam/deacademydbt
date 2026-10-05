{{ config({ "materialized":'incremental',
 "incremental_strategy":'merge',
 "unique_key":'STORE_ID',
 "transient":true,
 "alias":'STORES_TRANSFORM',
 "pre_hook": macros_copy_stores_csv('STORES_COPY'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT 
    STORE AS STORE_ID
    ,TYPE AS STORE_TYPE
    ,SIZE AS STORE_SIZE
    ,INSERT_DTS AS INSERT_DTS
    ,UPDATE_DTS AS UPDATE_DTS
FROM {{source('source','STORES_COPY')}}

{% if is_incremental() %}
    where UPDATE_DTS > (select max(UPDATE_DTS) from {{this}})
    {% endif %}
)

SELECT
    t.STORE_ID::INT AS STORE_ID
    ,d.DEPT::INT AS DEPT_ID
    ,t.STORE_TYPE::VARCHAR(255) AS STORE_TYPE
    ,t.STORE_SIZE::INT AS STORE_SIZE
    ,t.INSERT_DTS::TIMESTAMP_NTZ(6) AS INSERT_DTS
    ,t.UPDATE_DTS::TIMESTAMP_NTZ(6) AS UPDATE_DTS
FROM transform t
JOIN {{source('source','DEPARTMENTS_COPY')}} d
    ON t.STORE_ID = d.STORE
ORDER BY
    STORE_ID, DEPT_ID