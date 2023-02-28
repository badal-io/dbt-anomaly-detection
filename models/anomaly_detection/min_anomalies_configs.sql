{{ config(materialized='table', tags=["config_selection"]) }}

SELECT configs.{{ var('app_event') }}, configs.control_config, 
    configs.anomalies, configs.RMSD_prcnt
  FROM {{ref('filtered_nonrecent_configs')}} AS configs
  INNER JOIN {{ref('min_anomalies')}} AS min_anomalies
    ON configs.anomalies = min_anomalies.anomalies
      AND configs.{{ var('app_event') }} = min_anomalies.{{ var('app_event') }}
  ORDER BY configs.{{ var('app_event') }}, RMSD_prcnt DESC
