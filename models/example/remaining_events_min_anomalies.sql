{{ config(materialized='table', tags=["config_selection"]) }}

SELECT app_event, MIN(anomalies) AS anomalies 
  FROM {{ref('remaining_events_features_null_filtered')}}
  GROUP BY app_event
  ORDER BY app_event