{% macro create_models() %}

    {% for model in var('models') %}

    {{ log(model) }}
    {{ print(model) }}

    create or replace model `{{ target.database }}`.`{{ target.schema }}`.`derived_models_{{ model }}`
    options(MODEL_TYPE="ARIMA_PLUS",TIME_SERIES_TIMESTAMP_COL="time_stamps",TIME_SERIES_DATA_COL="event_count",TIME_SERIES_ID_COL=['app_event', 'agg_tag'],HORIZON=120,HOLIDAY_REGION="CA")as (
        
SELECT
  time_stamps,
  event_count,
  app_event,
  agg_tag
FROM
  `ld-snowplow`.`dbt_anomaly_detection`.`aggregation_outliers_short`
WHERE
  DATE(time_stamps) >= DATE_SUB("2023-02-09", INTERVAL 60 DAY)
  AND DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 15 DAY)
  AND agg_tag = "{{ var('models')[model]['period'] }}"
    );

    {% endfor %}

{% endmacro %}