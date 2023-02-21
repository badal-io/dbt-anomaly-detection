-- 2 periods of training * 2 probabality threshold * 4 aggregation levels 
{{ config(materialized='table', tags=["modelling"]) }}

  WITH test_set AS (
    SELECT
    time_stamps,
          event_count,
          app_event,
          agg_tag
        FROM
          {{ ref('all_agg_derived_cutoff') }}
        WHERE

      {% for model in var('models') %}

        (agg_tag = "{{ var('models')[model]['period'] }}" AND DATE(time_stamps) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('models')[model]['forecast_interval'] }} DAY))

        {{ " OR " if not loop.last }}

      {% endfor %}
  )

    {% for threshold in var('anomaly_detection_prob_thresholds') %}

      {% set outer_loop = loop %}

      {% for model in var('models') %}

        SELECT
          app_event, agg_tag,
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
            model `{{ target.database }}`.`{{ target.schema }}`.`derived_models_{{ model }}`,
            struct( {{threshold}} as anomaly_prob_threshold),
            (select * from (select * from test_set where agg_tag = "{{ var('models')[model]['period'] }}" ))
          )

        {{ "union all" if not loop.last or not outer_loop.last }}

      {% endfor %}

    {% endfor %}
