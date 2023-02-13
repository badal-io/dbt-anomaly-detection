

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_anomalies`
  
  
  OPTIONS()
  as (
    

SELECT app_event, MIN(anomalies) AS anomalies 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_features_null_filtered`
  GROUP BY app_event
  ORDER BY app_event
  );
  