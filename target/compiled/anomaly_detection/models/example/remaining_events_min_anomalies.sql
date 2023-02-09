

SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_features_null_filtered`
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB