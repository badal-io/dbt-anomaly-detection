{{ config(materialized='table') }}

 SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM {{ref('trade_off_phase')}}
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB
