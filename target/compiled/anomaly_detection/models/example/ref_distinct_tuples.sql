
SELECT DISTINCT app_event
FROM `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
WHERE app_event LIKE '%add%'
UNION ALL
SELECT DISTINCT app_event
FROM `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
WHERE app_event NOT LIKE '%ad%'
ORDER BY app_event