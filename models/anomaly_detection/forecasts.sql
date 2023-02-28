-- 3 periods of training * 2 probabality threshold * 4 aggregation levels

{{ config(materialized='table', tags=["modelling"]) }}

-- depends_on: {{ ref('IQR_outliers') }}


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

    {% for threshold in var('anomaly_detection_prob_thresholds') %}

      {% set outer_loop = loop %}

      {% for model in var('models') %}

        SELECT
          {{ var('app_event') }}, agg_tag,
          time_stamps,
          "{{threshold}}" AS prob_threshold,
          "derived_models_{{ model }}" AS training_period,
          event_count,
          is_anomaly,
          lower_bound,
          upper_bound,
          anomaly_probability
        FROM
          ml.detect_anomalies(
            model `{{ target.database }}`.`{{ target.schema }}`.`models_{{ model }}`,
            struct( {{threshold}} as anomaly_prob_threshold),
            (select * from (select * from test_set where agg_tag = "{{ var('models')[model]['period'] }}" ))
          )

        {{ "union all" if not loop.last or not outer_loop.last }}

      {% endfor %}

    {% endfor %}
