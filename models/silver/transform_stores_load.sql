{{ config({ "materialized":'table',
 "transient":true,
 "alias":'STORES_TRANSFORM',
 "pre_hook": macros_copy_stores_csv('STORES_COPY'),
 "schema": 'SILVER'
})}}

WITH transform AS(
SELECT 
    STORE AS STORE
    ,TYPE AS TYPE
    ,SIZE AS SIZE
    ,INSERT_DTS AS INSERT_DTS
    ,UPDATE_DTS AS UPDATE_DTS
FROM {{source('source','STORES_COPY')}}
)

SELECT *
FROM transform