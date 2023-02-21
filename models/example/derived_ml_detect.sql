-- 2 periods of training * 2 probabality threshold * 4 aggregation levels 
{{ config(materialized='table', tags=["modelling"]) }}

  WITH test_set AS (
  SELECT
  time_stamps,
        event_count,
        app_event,
        agg_tag
      FROM
        `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff`  
      WHERE (agg_tag = "4hr" AND DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 10 DAY)) 
      OR (agg_tag = "8hr" AND DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 10 DAY))
      OR (agg_tag = "12hr" AND DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 15 DAY))
      OR (agg_tag = "24hr" AND DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 15 DAY))
  )

    {% for threshold in var('anomaly_detection_prob_thresholds') %}

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
        model `{{ target.database }}`.`{{ target.schema }}`.`derived_models_{{ model }}`
        struct( {{threshold}} as anomaly_prob_threshold),
        (select * from (select * from test_set where agg_tag = "{{ var('models')[model]['period'] }}" ))
        )

      {% endfor %}

    {% endfor %}