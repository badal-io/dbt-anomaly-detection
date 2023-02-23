{{ config(materialized='table', tags=["data_preparation"]) }}
SELECT collector_tstamp, event_id, event_type, app_id
FROM {{source('sampled_data', 'sample_table')}}
WHERE DATE(collector_tstamp) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('data_interval') }} DAY) AND DATE(collector_tstamp) < {{ var('start_date') }}