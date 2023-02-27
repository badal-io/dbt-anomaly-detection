{{ config(materialized='table', tags=["data_preparation"]) }}

select time_stamps, {{ var('app_event') }}, agg_tag, event_count
from(
select time_stamps, strt_time, main.{{ var('app_event') }}, main.agg_tag, event_count
from {{ref('all_agg_derived')}} as main
inner join {{ref('count_cutoff')}} as cutoff
on main.agg_tag = cutoff.agg_tag
and main.{{ var('app_event') }} = cutoff.{{ var('app_event') }}
order by main.{{ var('app_event') }}, main.agg_tag, time_stamps)
where time_stamps >= strt_time