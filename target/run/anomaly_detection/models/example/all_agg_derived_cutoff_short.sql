

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff_short`
  
  
  OPTIONS()
  as (
    

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff`
where DATE(time_stamps) < DATE_SUB(CURRENT_DATE(), INTERVAL 15 DAY)
  );
  