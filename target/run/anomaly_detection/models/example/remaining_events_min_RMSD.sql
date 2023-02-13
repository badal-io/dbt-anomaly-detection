

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_RMSD`
  
  
  OPTIONS()
  as (
    

SELECT app_event, MIN(RMSD_prcnt) AS RMSD_prcnt 
  FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_anomalies_results`
  GROUP BY app_event
  ORDER BY app_event
  );
  