
SELECT app_event, control_config, anomalies, RMSD_prcnt, neg_lower
FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_RMSD_results`
WHERE app_event LIKE '%add%'
UNION ALL 
SELECT app_event, control_config, anomalies, RMSD_prcnt, neg_lower
FROM `ld-snowplow`.`dbt_anomaly_detection`.`remaining_events_min_RMSD_results`
WHERE app_event NOT LIKE '%ad%'
ORDER BY app_event