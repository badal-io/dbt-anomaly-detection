

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_min_anomalies_results`
  
  
  OPTIONS()
  as (
    

  SELECT neg_lower_criteria_res.app_event, neg_lower_criteria_res.LoB, neg_lower_criteria_res.control_config, 
    neg_lower_criteria_res.anomalies, neg_lower_criteria_res.RMSD_prcnt, neg_lower_criteria_res.neg_lower 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_phase` AS neg_lower_criteria_res
  INNER JOIN `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_min_anomalies` AS min_neg_lower_min_anomalies
    ON neg_lower_criteria_res.anomalies = min_neg_lower_min_anomalies.anomalies
      AND neg_lower_criteria_res.app_event = min_neg_lower_min_anomalies.app_event
      AND neg_lower_criteria_res.LoB = min_neg_lower_min_anomalies.LoB
  ORDER BY neg_lower_criteria_res.app_event, neg_lower_criteria_res.LoB, RMSD_prcnt DESC
  );
  