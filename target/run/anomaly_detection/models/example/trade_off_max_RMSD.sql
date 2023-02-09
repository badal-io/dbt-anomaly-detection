

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_max_RMSD`
  
  
  OPTIONS()
  as (
    

SELECT app_event, LoB, MAX(RMSD_prcnt) AS RMSD_prcnt 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`trade_off_min_anomalies_results`
  GROUP BY app_event, LoB
  ORDER BY app_event, LoB
  );
  