

SELECT anomalies_criteria_res_dbt.app_event, anomalies_criteria_res_dbt.LoB, anomalies_criteria_res_dbt.control_config, 
    anomalies_criteria_res_dbt.anomalies, anomalies_criteria_res_dbt.RMSD_prcnt, anomalies_criteria_res_dbt.neg_lower 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_anomalies_results` AS anomalies_criteria_res_dbt
  INNER JOIN `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_RMSD` AS min_anomalies_max_RMSD
    ON anomalies_criteria_res_dbt.RMSD_prcnt = min_anomalies_max_RMSD.RMSD_prcnt
      AND anomalies_criteria_res_dbt.app_event = min_anomalies_max_RMSD.app_event
      AND anomalies_criteria_res_dbt.LoB = min_anomalies_max_RMSD.LoB
  ORDER BY anomalies_criteria_res_dbt.app_event, anomalies_criteria_res_dbt.LoB, control_config