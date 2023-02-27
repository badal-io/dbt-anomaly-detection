{{ config(materialized='table', tags=["data_preparation"]) }}

select *
from {{ref('aggregations_cutoff')}}
where DATE(time_stamps) < DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('anomaly_detection_forecast_interval') }} DAY)