{{ config(materialized='table') }}
SELECT collector_tstamp, event, user_event_name, app_id
FROM {{source('derived_app_event_1', 'web_purchase_exported')}}
WHERE DATE(collector_tstamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) AND DATE(collector_tstamp) < CURRENT_DATE()

UNION ALL

SELECT collector_tstamp, event, user_event_name, app_id
FROM {{source('derived_app_event_2', 'pco_web_apply_filter_exported')}}
WHERE DATE(collector_tstamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) AND DATE(collector_tstamp) < CURRENT_DATE()