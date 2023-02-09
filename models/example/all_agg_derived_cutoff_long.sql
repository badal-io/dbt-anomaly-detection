{{ config(materialized='table') }}

select *
from {{ref('all_agg_derived_cutoff')}}
where DATE(time_stamps) < DATE_SUB(CURRENT_DATE(), INTERVAL 10 DAY)