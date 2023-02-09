-- 2 periods of training * 2 probabality threshold * 4 aggregation levels 
{{ config(materialized='table') }}

  WITH test_set AS (
  SELECT
  time_stamps,
        event_count,
        app_event,
        LoB,
        agg_tag
      FROM
        {{ref('all_agg_derived_cutoff')}}  
      WHERE (agg_tag = "4hr" AND DATE(time_stamps) >= DATE_SUB(current_date(), INTERVAL 10 DAY)) 
      OR (agg_tag = "8hr" AND DATE(time_stamps) >= DATE_SUB(current_date(), INTERVAL 10 DAY))
      OR (agg_tag = "12hr" AND DATE(time_stamps) >= DATE_SUB(current_date(), INTERVAL 15 DAY))
      OR (agg_tag = "24hr" AND DATE(time_stamps) >= DATE_SUB(current_date(), INTERVAL 15 DAY))
  )

  
  {% for threshold in var('anomaly_detection_prob_thresholds') %}

    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_1mon_4hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_1mon_4hr'), '(select * from test_set where agg_tag = "4hr" )', threshold) }} 

    UNION ALL

    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_2mon_4hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_2mon_4hr'), '(select * from test_set where agg_tag = "4hr" )', threshold) }} 

    UNION ALL

    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_05mon_4hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_05mon_4hr'), '(select * from test_set where agg_tag = "4hr" )', threshold) }}       

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_1mon_8hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_1mon_8hr'), '(select * from test_set where agg_tag = "8hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_2mon_8hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_2mon_8hr'), '(select * from test_set where agg_tag = "8hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_05mon_8hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_05mon_8hr'), '(select * from test_set where agg_tag = "8hr" )', threshold) }}       

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_1mon_12hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_1mon_12hr'), '(select * from test_set where agg_tag = "12hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_2mon_12hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_2mon_12hr'), '(select * from test_set where agg_tag = "12hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_05mon_12hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_05mon_12hr'), '(select * from test_set where agg_tag = "12hr" )', threshold) }}       

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_1mon_24hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_1mon_24hr'), '(select * from test_set where agg_tag = "24hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_2mon_24hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_2mon_24hr'), '(select * from test_set where agg_tag = "24hr" )', threshold) }} 

    UNION ALL
    
    SELECT
      app_event, LoB, agg_tag, time_stamps, "{{threshold}}" AS prob_threshold, "derived_models_05mon_24hr" AS training_period, event_count, is_anomaly, lower_bound, upper_bound, anomaly_probability
    FROM
      {{ dbt_ml.detect_anomalies(ref('derived_models_05mon_24hr'), '(select * from test_set where agg_tag = "24hr" )', threshold) }}       

  {% if not loop.last %}
  UNION ALL
  {% else %}
  ORDER BY
  agg_tag,
  time_stamps,
  app_event,
  LoB,
  prob_threshold,
  training_period
  {% endif %}

{% endfor %}
