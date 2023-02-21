{{ config(materialized='table', tags=["data_preparation"]) }}
SELECT collector_tstamp, event, user_event_name, app_id
FROM {{source('derived_app_event_1', 'web_purchase_exported')}}
WHERE DATE(collector_tstamp) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('data_interval') }} DAY) AND DATE(collector_tstamp) < {{ var('start_date') }}

UNION ALL

SELECT collector_tstamp, event, user_event_name, app_id
FROM {{source('derived_app_event_2', 'pco_web_apply_filter_exported')}}
WHERE DATE(collector_tstamp) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('data_interval') }} DAY) AND DATE(collector_tstamp) < {{ var('start_date') }}