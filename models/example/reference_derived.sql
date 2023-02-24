{{ config(materialized='table', tags=["data_preparation"]) }}
SELECT {{ var('collector_tstamp') }}, {{ var('event_id') }}, {{ var('event_type') }}, {{ var('app_id') }}
FROM {{source(var('source_name'), var('source_table'))}}
WHERE DATE( {{ var('collector_tstamp') }} ) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('data_interval') }} DAY) AND DATE( {{ var('collector_tstamp') }} ) < {{ var('start_date') }}