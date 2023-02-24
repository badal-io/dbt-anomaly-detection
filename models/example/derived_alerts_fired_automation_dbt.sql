{{ config(materialized='table', tags=["config_selection"]) }}
  
  WITH ml_detect_updated AS (
    SELECT app_event, 
      CONCAT(agg_tag, '_', prob_threshold, "threshold", '_', RTRIM(LTRIM(training_period, "derived_models_"), CONCAT('_', agg_tag))) AS control_config,
      time_stamps, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM {{ref('ml_detect_tweaked')}}
  )
  SELECT time_stamps, all_configs.app_event AS app_event, control_table.control_config AS control_config, 
    anomalies, RMSD_prcnt, neg_lower, event_count, lower_bound, upper_bound, anomaly_probability, is_anomaly
  FROM ml_detect_updated AS all_configs 
  INNER JOIN {{ref('remaining_events_min_RMSD_results')}} AS control_table 
    ON all_configs.app_event = control_table.app_event
      AND all_configs.control_config = control_table.control_config
  ORDER BY all_configs.app_event, time_stamps
