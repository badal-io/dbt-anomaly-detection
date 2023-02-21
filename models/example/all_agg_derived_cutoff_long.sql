{{ config(materialized='table', tags=["data_preparation"]) }}

select *
from {{ref('all_agg_derived_cutoff')}}
where DATE(time_stamps) < DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('models')["1mon_8hr"]['forecast_interval'] }} DAY)