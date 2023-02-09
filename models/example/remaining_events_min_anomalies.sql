{{ config(materialized='table') }}

SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM {{ref('remaining_events_features_null_filtered')}}
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB