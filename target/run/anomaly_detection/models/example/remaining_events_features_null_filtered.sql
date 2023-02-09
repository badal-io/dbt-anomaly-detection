

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_features_null_filtered`
  
  
  OPTIONS()
  as (
    

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_features`
where RMSD_prcnt is not null
  );
  