

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_anomalies`
  
  
  OPTIONS()
  as (
    

SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB
  );
  