{{ config(materialized='table') }}

WITH pairs AS (
  SELECT CONCAT(app_id, '_', event_type) AS app_event, LoB, time_stamps, event_count, agg_tag  
  FROM {{ref('all_agg_derived')}}
)

select time_stamps, app_event, LoB, agg_tag, event_count
from(
select time_stamps, strt_time, pairs.app_event, pairs.LoB, pairs.agg_tag, event_count
from pairs
inner join {{ref('count_cutoff')}} as cutoff
on pairs.agg_tag = cutoff.agg_tag
and pairs.app_event = cutoff.app_event
and pairs.LoB = cutoff.LoB
order by pairs.app_event, pairs.LoB, pairs.agg_tag, time_stamps)
where time_stamps >= strt_time