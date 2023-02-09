{{ config(materialized='table') }}

SELECT app_event, LoB, MAX(RMSD_prcnt) AS RMSD_prcnt 
  FROM {{ref('trade_off_min_anomalies_results')}}
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB