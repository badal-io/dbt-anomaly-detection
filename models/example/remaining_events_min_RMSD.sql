{{ config(materialized='table') }}

SELECT app_event, MIN(RMSD_prcnt) AS RMSD_prcnt 
  FROM {{ref('remaining_events_min_anomalies_results')}}
  GROUP BY app_event
  ORDER BY app_event