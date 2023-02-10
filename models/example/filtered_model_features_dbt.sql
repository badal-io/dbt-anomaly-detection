{{ config(materialized='table') }}
SELECT features.app_event, control_config, anomalies, RMSD_prcnt, neg_lower
FROM {{ref('derived_nonrecent_events')}} AS non_recent
INNER JOIN {{ref('derived_model_features_dbt')}} AS features
  ON non_recent.app_event = features.app_event