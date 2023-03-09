{{ config(materialized='table', tags=["config_selection"]) }}

  SELECT
    time_stamps,
    alerting.app_event AS app_event,
    control_config,
    anomalies,
    RMSD_prcnt,
    event_count,
    forecast_value,
    lower_bound,
    upper_bound,
    anomaly_probability,
    is_anomaly
  FROM
    {{ref('alerting_base')}} AS alerting
  LEFT JOIN
    {{ref('predictions')}} AS pred
  ON
    alerting.app_event = pred.app_event
    AND alerting.time_stamps = pred.forecast_timestamp
  WHERE
    alerting.control_config LIKE CONCAT('%',pred.training_period,'%') 

  -- this model updated the alerting base table with the best possible forecasts

