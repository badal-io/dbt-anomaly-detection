

select agg_tag, app_event, min(time_stamps) as strt_time
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived`
where event_count > 50
group by app_event, agg_tag 
order by app_event, agg_tag