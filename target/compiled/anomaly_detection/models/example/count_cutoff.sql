

WITH pairs AS (
  SELECT CONCAT(app_id, '_', event_type) AS app_event, LoB, time_stamps, event_count, agg_tag  
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived`
)

select agg_tag, app_event, LoB, min(time_stamps) as strt_time
from pairs
where event_count > 50
group by app_event, LoB, agg_tag 
order by app_event, LoB, agg_tag