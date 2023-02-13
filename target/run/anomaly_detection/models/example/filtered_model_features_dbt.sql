

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
  
  
  OPTIONS()
  as (
    
SELECT features.app_event, control_config, anomalies, RMSD_prcnt, neg_lower
FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_nonrecent_events` AS non_recent
INNER JOIN `ld-snowplow`.`dbt_anomaly_detection`.`derived_model_features_dbt` AS features
  ON non_recent.app_event = features.app_event
  );
  