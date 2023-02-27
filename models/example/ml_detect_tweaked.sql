{{ config(materialized='table', tags=["modelling"]) }}
  
  with neg_bound_reset as (
SELECT {{ var('app_event') }}, agg_tag, time_stamps, prob_threshold, training_period, event_count, 
  IF (lower_bound < 0, {{ var('neg_lower_bound_reset') }}, (1 / {{ var('bounds_coeff') }}) * lower_bound) AS lower_bound, {{ var('bounds_coeff') }} * upper_bound AS upper_bound, anomaly_probability, is_anomaly
FROM {{ref('derived_ml_detect')}} )

SELECT {{ var('app_event') }}, agg_tag, time_stamps, prob_threshold, training_period, event_count, 
  lower_bound, upper_bound, anomaly_probability,
  (upper_bound < event_count OR event_count < lower_bound) AS is_anomaly
FROM neg_bound_reset