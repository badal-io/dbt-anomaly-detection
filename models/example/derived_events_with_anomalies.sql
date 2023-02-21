{{ config(materialized='table', tags=["config_selection"]) }}
SELECT time_stamps, app_event, event_count AS event_count_anomalous_yesterday
FROM {{ref('derived_alerts_fired_automation_dbt')}}
WHERE DATE(time_stamps) = {{ var('start_date') }} - 1 
  AND is_anomaly 
