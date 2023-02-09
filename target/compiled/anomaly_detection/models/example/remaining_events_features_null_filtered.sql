

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_features`
where RMSD_prcnt is not null