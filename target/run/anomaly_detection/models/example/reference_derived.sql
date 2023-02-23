

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`reference_derived`
  
  
  OPTIONS()
  as (
    
SELECT collector_tstamp, event_id, event_type, app_id
FROM `ld-snowplow`.`dbt_rhashemi`.`sample_table`
WHERE DATE(collector_tstamp) >= DATE_SUB("2023-02-09", INTERVAL 90 DAY) AND DATE(collector_tstamp) < "2023-02-09"
  );
  