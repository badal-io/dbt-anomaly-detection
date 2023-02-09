
  
  WITH ml_detect_updated AS (
    SELECT app_event, LoB, 
      CONCAT(agg_tag, '_', prob_threshold, "threshold", '_', RTRIM(LTRIM(training_period, "derived_models_"), CONCAT('_', agg_tag))) AS control_config,
      time_stamps, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM `ld-snowplow`.`dbt_anomaly_detection`.`ml_detect_tweaked`
  )
  SELECT time_stamps, all_configs.app_event AS app_event, all_configs.LoB AS LoB, control_table.control_config AS control_config, 
    anomalies, RMSD_prcnt, neg_lower, model_quality_tag,
    event_count, lower_bound, upper_bound, anomaly_probability, is_anomaly
  FROM ml_detect_updated AS all_configs 
  INNER JOIN `ld-snowplow`.`dbt_anomaly_detection`.`filtered_all_models` AS control_table 
    ON all_configs.app_event = control_table.app_event
      AND all_configs.LoB = control_table.LoB
      AND all_configs.control_config = control_table.control_config
  ORDER BY all_configs.app_event, all_configs.LoB, time_stamps