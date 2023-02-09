

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`filtered_all_models`
  
  
  OPTIONS()
  as (
    
SELECT app_event, LoB, control_config, anomalies, RMSD_prcnt, neg_lower, 
  CASE WHEN (neg_lower = 0 AND anomalies < 5 AND RMSD_prcnt > 0.40 AND RMSD_prcnt < 5.00 ) THEN "ideal_model" ELSE "non_ideal_model" END AS model_quality_tag,
FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_models`
WHERE app_event LIKE '%add%'
UNION ALL 
SELECT app_event, LoB, control_config, anomalies, RMSD_prcnt, neg_lower, 
  CASE WHEN (neg_lower = 0 AND anomalies < 5 AND RMSD_prcnt > 0.40 AND RMSD_prcnt < 5.00 ) THEN "ideal_model" ELSE "non_ideal_model" END AS model_quality_tag,
FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_models`
WHERE app_event NOT LIKE '%ad%'
ORDER BY app_event, LoB
  );
  