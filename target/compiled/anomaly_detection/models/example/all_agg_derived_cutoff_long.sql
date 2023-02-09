

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff`
where DATE(time_stamps) < DATE_SUB(CURRENT_DATE(), INTERVAL 10 DAY)