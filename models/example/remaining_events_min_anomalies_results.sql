{{ config(materialized='table') }}

SELECT neg_lower_criteria_res.app_event, neg_lower_criteria_res.control_config, 
    neg_lower_criteria_res.anomalies, neg_lower_criteria_res.RMSD_prcnt, neg_lower_criteria_res.neg_lower 
  FROM {{ref('remaining_events_features_null_filtered')}} AS neg_lower_criteria_res
  INNER JOIN {{ref('remaining_events_min_anomalies')}} AS min_neg_lower_min_anomalies
    ON neg_lower_criteria_res.anomalies = min_neg_lower_min_anomalies.anomalies
      AND neg_lower_criteria_res.app_event = min_neg_lower_min_anomalies.app_event
  ORDER BY neg_lower_criteria_res.app_event, RMSD_prcnt DESC
