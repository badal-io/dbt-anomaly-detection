

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`ml_detect_tweaked`
  
  
  OPTIONS()
  as (
     
  
  with neg_bound_reset as (
SELECT app_event, agg_tag, time_stamps, prob_threshold, training_period, event_count, 
  IF(lower_bound<0, 2, 0.77*lower_bound) AS lower_bound, 1.3*upper_bound AS upper_bound, anomaly_probability, is_anomaly
FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_ml_detect` )

SELECT app_event, agg_tag, time_stamps, prob_threshold, training_period, event_count, 
  lower_bound, upper_bound, anomaly_probability,
  (upper_bound < event_count OR event_count < lower_bound) AS is_anomaly
FROM neg_bound_reset
  );
  