

select time_stamps, app_event, agg_tag, event_count
from(
select time_stamps, strt_time, main.app_event, main.agg_tag, event_count
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived` as main
inner join `ld-snowplow`.`dbt_anomaly_detection`.`count_cutoff` as cutoff
on main.agg_tag = cutoff.agg_tag
and main.app_event = cutoff.app_event
order by main.app_event, main.agg_tag, time_stamps)
where time_stamps >= strt_time