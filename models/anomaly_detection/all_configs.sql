{{ config(materialized='table', tags=["config_selection"]) }}
  
  SELECT
    {{ var('app_event') }},
    CONCAT(prob_threshold, "threshold", '_', training_period) AS control_config,
    SUM(CASE WHEN is_anomaly = TRUE THEN 1 ELSE 0 END) AS anomalies,
    SQRT(AVG( POWER(upper_bound - lower_bound, 2) ) ) / AVG(lower_bound) AS RMSD_prcnt
  FROM {{ref('reset_forecasts')}} AS all_configs
  GROUP BY
    {{ var('app_event') }},
    control_config
  ORDER BY
    control_config,
    {{ var('app_event') }}