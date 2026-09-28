{% macro macros_copy_stores_csv(table_nm) %} 

delete from {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }};

COPY INTO {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }} 
FROM 
(
SELECT
    $1 AS Store,
    $2 AS Type,
    $3 AS Size,
    CURRENT_TIMESTAMP() AS INSERT_DTS,
    CURRENT_TIMESTAMP() AS UPDATE_DTS,
FROM @{{ var('stores_stage_name') }}
)
FILE_FORMAT = {{var ('file_format_json') }}
PURGE={{ var('purge_status') }}
FORCE = TRUE
;

{% endmacro %}