{{ config(materialized='table', tags=["config_selection"]) }}
SELECT DISTINCT app_event
FROM {{ref('filtered_model_features_dbt')}}
WHERE app_event LIKE '%add%'
UNION ALL
SELECT DISTINCT app_event
FROM {{ref('filtered_model_features_dbt')}}
WHERE app_event NOT LIKE '%ad%'
ORDER BY app_event
