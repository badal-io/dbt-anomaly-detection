{{ config(materialized='table') }}

SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM {{ref('filtered_model_features_dbt')}}
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB