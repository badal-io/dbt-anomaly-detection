

    create or replace model `ld-snowplow`.`dbt_anomaly_detection`.`derived_models_2mon_4hr`
    options(MODEL_TYPE="ARIMA_PLUS",TIME_SERIES_TIMESTAMP_COL="time_stamps",TIME_SERIES_DATA_COL="event_count",TIME_SERIES_ID_COL=['app_event', 'agg_tag'],HORIZON=120,HOLIDAY_REGION="CA")as (
        
SELECT
  time_stamps,
  event_count,
  app_event,
  agg_tag
FROM
  `ld-snowplow`.`dbt_anomaly_detection`.`aggregation_outliers_short`
WHERE
  DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 90 DAY)
  AND DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 10 DAY)
  AND agg_tag = "4hr"
    );
    