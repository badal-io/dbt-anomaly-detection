{{ config(materialized='ephemeral', tags=["data_preparation"]) }}

with bounds_agg as (
select time_stamps, bounds.{{ var('app_event') }} as {{ var('app_event') }}, bounds.agg_tag as agg_tag, event_count, LB, UB
from {{ref('IQR_bounds')}} as bounds
inner join {{ref('train_data')}} as aggs
on bounds.{{ var('app_event') }} = aggs.{{ var('app_event') }}
and bounds.agg_tag = aggs.agg_tag
order by bounds.{{ var('app_event') }}, bounds.agg_tag)

select time_stamps, {{ var('app_event') }}, agg_tag,
case when event_count > UB then UB
when event_count < LB then LB
else event_count
end as event_count
from bounds_agg
order by {{ var('app_event') }}, agg_tag, time_stamps