{{ config(materialized='table', tags=["data_preparation"]) }}

WITH pairs AS (
  SELECT CONCAT(app_id, '_', event_type) AS app_event, time_stamps, event_count, agg_tag  
  FROM {{ref('all_agg_derived')}}
)

select time_stamps, app_event, agg_tag, event_count
from(
select time_stamps, strt_time, pairs.app_event, pairs.agg_tag, event_count
from pairs
inner join {{ref('count_cutoff')}} as cutoff
on pairs.agg_tag = cutoff.agg_tag
and pairs.app_event = cutoff.app_event
order by pairs.app_event, pairs.agg_tag, time_stamps)
where time_stamps >= strt_time