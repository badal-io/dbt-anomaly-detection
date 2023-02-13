{{
    config(
        materialized='model',
        ml_config={
            'MODEL_TYPE': 'ARIMA_PLUS',
            'TIME_SERIES_TIMESTAMP_COL': 'time_stamps',
            'TIME_SERIES_DATA_COL': 'event_count',
            'TIME_SERIES_ID_COL': ['app_event', 'agg_tag'], 
            'HORIZON': var('anomaly_detection_horizon'), 
            'HOLIDAY_REGION': 'CA'
        }
    )
}}
SELECT
  time_stamps,
  event_count,
  app_event,
  agg_tag
FROM
  {{ ref('aggregation_outliers_short') }}
WHERE
  DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 30 DAY)
  AND DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 10 DAY)
  AND agg_tag = "8hr"