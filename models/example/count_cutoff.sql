{{ config(materialized='table') }}

WITH pairs AS (
  SELECT CONCAT(app_id, '_', event_type) AS app_event, time_stamps, event_count, agg_tag  
  FROM {{ref('all_agg_derived')}}
)

select agg_tag, app_event, min(time_stamps) as strt_time
from pairs
where event_count > 50
group by app_event, agg_tag 
order by app_event, agg_tag 
