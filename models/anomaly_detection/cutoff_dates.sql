{{ config(materialized='ephemeral', tags=["data_preparation"]) }}

select agg_tag, {{ var('app_event') }}, min(time_stamps) as strt_time
from {{ref('aggregations')}}
where event_count > {{ var('cutoff_count') }}
group by {{ var('app_event') }}, agg_tag 
order by {{ var('app_event') }}, agg_tag 
