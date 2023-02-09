

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`reference_derived`
  
  
  OPTIONS()
  as (
    
SELECT collector_tstamp, event, user_event_name, app_id
FROM `ld-snowplow`.`dbt_rhashemi`.`web_purchase_exported`
WHERE DATE(collector_tstamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) AND DATE(collector_tstamp) < CURRENT_DATE()

UNION ALL

SELECT collector_tstamp, event, user_event_name, app_id
FROM `ld-snowplow`.`dbt_rhashemi`.`pco_web_apply_filter_exported`
WHERE DATE(collector_tstamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY) AND DATE(collector_tstamp) < CURRENT_DATE()
  );
  