{% macro macros_copy_fact_csv(table_nm) %} 

delete from {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }};

COPY INTO {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }} 
FROM 
(
SELECT
    $1 AS Store,
    $2 AS Date,
    $3 AS Temperature,
    $4 AS Fuel_Price,
    $5 AS MarkDown1,
    $6 AS MarkDown2,
    $7 AS MarkDown3,
    $8 AS MarkDown4,
    $9 AS MarkDown5,
    $10 AS CPI,
    $11 AS Unemployment,
    $12 AS IsHoliday,
    CURRENT_TIMESTAMP() AS INSERT_DTS,
    CURRENT_TIMESTAMP() AS UPDATE_DTS,
    metadata$filename AS SOURCE_FILE_NAME,
    metadata$file_row_number AS SOURCE_FILE_ROW_NUMBER
FROM @{{ var('fact_stage_name') }}
)
FILE_FORMAT = {{var ('file_format_json') }}
PURGE={{ var('purge_status') }}
FORCE = TRUE
;

{% endmacro %}