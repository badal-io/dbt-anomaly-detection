{{ config(materialized='table', tags=["config_selection"]) }}
SELECT features.{{ var('app_event') }}, control_config, anomalies, RMSD_prcnt
FROM {{ref('nonrecent_events')}} AS non_recent
INNER JOIN {{ref('all_configs')}} AS features
  ON non_recent.{{ var('app_event') }} = features.{{ var('app_event') }}