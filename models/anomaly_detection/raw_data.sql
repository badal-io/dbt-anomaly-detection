{{ config(materialized='ephemeral', tags=["data_preparation"]) }}
SELECT {{ var('collector_tstamp') }}, {{ var('event_id') }}, {{ var('app_event') }}
FROM {{source(var('source_name'), var('source_table'))}}
WHERE DATE({{ var('collector_tstamp') }}) >= DATE_SUB(PARSE_DATE("%Y-%m-%d", "{{ var('start_date') }}"), INTERVAL 90 DAY)
 AND DATE( {{ var('collector_tstamp') }} ) < PARSE_DATE("%Y-%m-%d", "{{ var('start_date') }}")