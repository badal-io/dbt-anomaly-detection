{{ config(materialized='table', tags=["config_selection"]) }}

SELECT {{ var('app_event') }}, MIN(RMSD_prcnt) AS RMSD_prcnt 
  FROM {{ref('remaining_events_min_anomalies_results')}}
  GROUP BY {{ var('app_event') }}
  ORDER BY {{ var('app_event') }}