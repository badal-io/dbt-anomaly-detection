{{ config(materialized='table', tags=["config_selection"]) }}
SELECT time_stamps, {{ var('app_event') }}, event_count AS event_count_anomalous_yesterday
FROM {{ref('alerting_base')}}
WHERE DATE(time_stamps) = PARSE_DATE("%Y-%m-%d", "{{ var('start_date') }}") - 1 
  AND is_anomaly 
