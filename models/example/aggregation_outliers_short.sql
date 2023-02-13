{{ config(materialized='table', tags=["data_preparation"]) }}

with bounds_agg as (
select time_stamps, bounds.app_event as app_event, bounds.agg_tag as agg_tag, event_count, LB, UB
from {{ref('aggregation_bounds_short')}} as bounds
inner join {{ref('all_agg_derived_cutoff_short')}} as aggs
on bounds.app_event = aggs.app_event
and bounds.agg_tag = aggs.agg_tag
order by bounds.app_event, bounds.agg_tag)

select time_stamps, app_event, agg_tag,
case when event_count > UB then UB
when event_count < LB then LB
else event_count
end as event_count
from bounds_agg
order by app_event, agg_tag, time_stamps