{{ config(materialized='table', tags=["config_selection"]) }}


with source_data as (
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
    alerting.control_config LIKE CONCAT('%',pred.training_period,'%') ),

  -- this model updated the alerting base table with the best possible forecasts

surrogate_key_data as (
    select *,
           {{ dbt_utils.generate_surrogate_key(['app_event', 'time_stamps']) }} as surrogate_key
    from source_data
)

select *
from surrogate_key_data