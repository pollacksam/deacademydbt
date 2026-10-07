{{ config({ "materialized":'incremental',
 "incremental_strategy":'merge',
 "unique_key":'DATE_ID',
 "alias":'DATE_DIM',
 "schema": 'GOLD'
})}}
 
WITH source_data AS(
SELECT DISTINCT
    TO_NUMBER(TO_CHAR(STORE_DATE, 'YYYYMMDD')) AS DATE_ID
    ,STORE_DATE
    ,CASE
        WHEN ISHOLIDAY='TRUE' THEN 'Yes'
        ELSE 'No'
    END AS IS_HOLIDAY
FROM {{ref('transform_departments_load')}}
)

SELECT
    src.DATE_ID,
    src.STORE_DATE,
    src.IS_HOLIDAY,

    {% if is_incremental() %}
        tgt.INSERT_DTS,
    {% else %}
        (CURRENT_TIMESTAMP()) AS INSERT_DTS,
    {% endif %}

    (CURRENT_TIMESTAMP()) AS UPDATE_DTS

FROM source_data src

{% if is_incremental() %}

LEFT JOIN {{ this }} tgt
    ON src.DATE_ID = tgt.DATE_ID

WHERE tgt.DATE_ID IS NULL
   OR src.STORE_DATE <> tgt.STORE_DATE
   OR src.IS_HOLIDAY <> tgt.IS_HOLIDAY

{% endif %}