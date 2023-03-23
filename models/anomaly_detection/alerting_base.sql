{{ config(materialized='ephemeral', tags=["config_selection"]) }}
  
  WITH ml_detect_updated AS (
    SELECT {{ var('app_event') }}, 
      CONCAT(prob_threshold, "threshold", '_', training_period) AS control_config,
      time_stamps, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM {{ref('reset_forecasts')}}
  )
  SELECT time_stamps, all_forecasts.{{ var('app_event') }} AS {{ var('app_event') }}, control_table.control_config AS control_config, 
    anomalies, RMSD_prcnt, event_count, lower_bound, upper_bound, anomaly_probability, is_anomaly
  FROM ml_detect_updated AS all_forecasts 
  INNER JOIN {{ref('control_table')}} AS control_table 
    ON all_forecasts.{{ var('app_event') }} = control_table.{{ var('app_event') }}
      AND all_forecasts.control_config = control_table.control_config
  ORDER BY all_forecasts.{{ var('app_event') }}, time_stamps
