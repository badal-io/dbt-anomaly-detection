

     select *
     from `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_RMSD_results`
     union all
     select *
     from `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_max_RMSD_results`
     order by app_event, LoB