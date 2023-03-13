{% macro create_models() %}

    {% for model in var('models') %}

      create or replace model `{{ target.database }}`.`{{ target.schema }}`.`models_{{ model }}`
      options(
        MODEL_TYPE="ARIMA_PLUS",
        TIME_SERIES_TIMESTAMP_COL="time_stamps",
        TIME_SERIES_DATA_COL="event_count",
        TIME_SERIES_ID_COL=['{{ var('app_event') }}', 'agg_tag'],
        HORIZON={{ var('anomaly_detection_horizon') }},
        HOLIDAY_REGION="{{ var('anomaly_detection_holiday_region') }}"
      ) as (
        SELECT
          time_stamps,
          event_count,
          {{ var('app_event') }},
          agg_tag
        FROM
          `{{ target.database }}`.`{{ target.schema }}`.`feedbacked_train`
        WHERE
          DATE(time_stamps) >= DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('models')[model]['train_interval'] }} DAY)
          AND DATE(time_stamps) < DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('anomaly_detection_forecast_interval') }} DAY)
          AND agg_tag = "{{ var('models')[model]['period'] }}"
      );

    {% endfor %}

{% endmacro %}
