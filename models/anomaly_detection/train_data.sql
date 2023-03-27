{{ config(materialized='ephemeral', tags=["data_preparation"]) }}

select *
from {{ref('aggregations_cutoff')}}
where DATE(time_stamps) < DATE_SUB(PARSE_DATE("%Y-%m-%d", "{{ var('start_date') }}"), INTERVAL {{ var('anomaly_detection_forecast_interval') }} DAY)