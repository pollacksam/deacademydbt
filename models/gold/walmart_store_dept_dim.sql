{{ config({ "materialized":'incremental',
 "incremental_strategy":'merge',
 "unique_key":['STORE_ID','DEPT_ID'],
 "alias":'STORE_DEPT_DIM',
 "schema": 'GOLD'
})}}
 
WITH source_data AS(
SELECT DISTINCT 
    d.STORE_ID
    ,d.DEPT_ID
    ,s.STORE_TYPE
    ,s.STORE_SIZE
FROM {{ref('transform_departments_load')}} d
JOIN {{ref('transform_stores_load')}} s
    ON d.STORE_ID = s.STORE_ID
)

SELECT
    src.STORE_ID,
    src.DEPT_ID,
    src.STORE_TYPE,
    src.STORE_SIZE,

    {% if is_incremental() %}
        tgt.INSERT_DTS,
    {% else %}
        CURRENT_TIMESTAMP() AS INSERT_DTS,
    {% endif %}

    CURRENT_TIMESTAMP() AS UPDATE_DTS

FROM source_data src

{% if is_incremental() %}

LEFT JOIN {{ this }} tgt
    ON src.STORE_ID = tgt.STORE_ID
    AND src.DEPT_ID = tgt.DEPT_ID

WHERE tgt.STORE_ID IS NULL
   OR src.STORE_TYPE <> tgt.STORE_TYPE
   OR src.STORE_SIZE <> tgt.STORE_SIZE

{% endif %}