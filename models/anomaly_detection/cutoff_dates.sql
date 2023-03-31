{{ config(materialized='ephemeral', tags=["data_preparation"]) }}

select agg_tag, {{ var('app_event') }}, min(time_stamps) as strt_time
from {{source(var('source_name'), var('source_table'))}}
where event_count > {{ var('cutoff_count') }}
group by {{ var('app_event') }}, agg_tag 
order by {{ var('app_event') }}, agg_tag 
