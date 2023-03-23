{{ config(materialized='ephemeral', tags=["config_selection"]) }}

SELECT {{ var('app_event') }}, MIN(anomalies) AS anomalies 
  FROM {{ref('filtered_nonrecent_configs')}}
  GROUP BY {{ var('app_event') }}
  ORDER BY {{ var('app_event') }}