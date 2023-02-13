{{ config(materialized='table', tags=["data_preparation"]) }}

select *
from {{ref('all_agg_derived_cutoff')}}
where DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 10 DAY)