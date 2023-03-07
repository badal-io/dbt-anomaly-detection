-- 3 periods of training * 2 probabality threshold * 4 aggregation levels

{{ config(materialized='table', tags=["modelling"]) }}

-- depends_on: {{ ref('forecasts') }}


  WITH test_set AS (
    SELECT
    time_stamps,
          event_count,
          {{ var('app_event') }},
          agg_tag
        FROM
          {{ ref('aggregations_cutoff') }}
        WHERE
        DATE(time_stamps) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('anomaly_detection_forecast_interval') }} DAY)
  )

      {% for model in var('models') %}

        SELECT
          {{ var('app_event') }}, agg_tag,
          forecast_timestamp,
          forecast_value,
          "derived_models_{{ model }}" AS training_period
        FROM
          ml.forecast(
            model `{{ target.database }}`.`{{ target.schema }}`.`models_{{ model }}`,
            struct( {{ var('anomaly_detection_horizon') }} as horizon, 
            {{ var('anomaly_detection_confidence_level') }} as confidence_level)
          )

        {{ "union all" if not loop.last }}

      {% endfor %}
