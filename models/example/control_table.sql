{{ config(materialized='table', tags=["config_selection"]) }}

SELECT configs.{{ var('app_event') }}, configs.control_config, 
    configs.anomalies, configs.RMSD_prcnt
  FROM {{ref('min_anomalies_configs')}} AS configs
  INNER JOIN {{ref('min_RMSD')}} AS min_RMSD
    ON configs.RMSD_prcnt = min_RMSD.RMSD_prcnt
      AND configs.{{ var('app_event') }} = min_RMSD.{{ var('app_event') }}
  ORDER BY configs.{{ var('app_event') }}, control_config