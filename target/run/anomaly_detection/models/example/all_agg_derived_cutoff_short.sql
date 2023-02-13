

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff_short`
  
  
  OPTIONS()
  as (
    

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff`
where DATE(time_stamps) < DATE_SUB("2023-02-09", INTERVAL 15 DAY)
  );
  