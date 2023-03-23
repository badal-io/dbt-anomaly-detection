{{ config(materialized='ephemeral', tags=["config_selection"]) }}

SELECT {{ var('app_event') }}, MIN(RMSD_prcnt) AS RMSD_prcnt 
  FROM {{ref('min_anomalies_configs')}}
  GROUP BY {{ var('app_event') }}
  ORDER BY {{ var('app_event') }}