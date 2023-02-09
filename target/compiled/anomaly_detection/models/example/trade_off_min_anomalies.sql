

 SELECT app_event, LoB, MIN(anomalies) AS anomalies 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_phase`
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB