
SELECT
  time_stamps,
  event_count,
  app_event,
  agg_tag
FROM
  `ld-snowplow`.`dbt_anomaly_detection`.`aggregation_outliers_short`
WHERE
  DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 60 DAY)
  AND DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 15 DAY)
  AND agg_tag = "24hr"