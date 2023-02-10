
SELECT time_stamps, app_event, event_count AS event_count_anomalous_yesterday
FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_alerts_fired_automation_dbt`
WHERE DATE(time_stamps) = CURRENT_DATE() - 1 
  AND is_anomaly