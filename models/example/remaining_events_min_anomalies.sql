{{ config(materialized='table', tags=["config_selection"]) }}

SELECT {{ var('app_event') }}, MIN(anomalies) AS anomalies 
  FROM {{ref('remaining_events_features_null_filtered')}}
  GROUP BY {{ var('app_event') }}
  ORDER BY {{ var('app_event') }}