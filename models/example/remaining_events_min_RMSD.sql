{{ config(materialized='table') }}

SELECT app_event, LoB, MIN(RMSD_prcnt) AS RMSD_prcnt 
  FROM {{ref('remaining_events_min_anomalies_results')}}
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB