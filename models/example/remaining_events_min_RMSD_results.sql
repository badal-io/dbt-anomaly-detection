{{ config(materialized='table', tags=["config_selection"]) }}

SELECT anomalies_criteria_res_dbt.{{ var('app_event') }}, anomalies_criteria_res_dbt.control_config, 
    anomalies_criteria_res_dbt.anomalies, anomalies_criteria_res_dbt.RMSD_prcnt, anomalies_criteria_res_dbt.neg_lower 
  FROM {{ref('remaining_events_min_anomalies_results')}} AS anomalies_criteria_res_dbt
  INNER JOIN {{ref('remaining_events_min_RMSD')}} AS min_anomalies_max_RMSD
    ON anomalies_criteria_res_dbt.RMSD_prcnt = min_anomalies_max_RMSD.RMSD_prcnt
      AND anomalies_criteria_res_dbt.{{ var('app_event') }} = min_anomalies_max_RMSD.{{ var('app_event') }}
  ORDER BY anomalies_criteria_res_dbt.{{ var('app_event') }}, control_config