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

SELECT *
FROM transform t