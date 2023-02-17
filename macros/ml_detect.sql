{% macro ml_detect() %}

create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`ml_detect`
  
  
  OPTIONS()
  as (
    -- 2 periods of training * 2 probabality threshold * 4 aggregation levels 


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


    SELECT
      app_event, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_1mon_4hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      
    ml.detect_anomalies(
        model `ld-snowplow`.`dbt_anomaly_detection`.`derived_models_1mon_4hr`,
        struct( {{threshold}} as anomaly_prob_threshold),
        (select * from (select * from test_set where agg_tag = "4hr" ))
    )

    {% if not loop.last %}
    UNION ALL
    {% else %}
    ORDER BY
    agg_tag,
    time_stamps,
    app_event,
    prob_threshold,
    training_period)

    {% endif %}

    {% endfor %}

{% endmacro %}