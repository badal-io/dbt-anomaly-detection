

SELECT MIN(time_stamps) AS strt_time, app_event, LoB 
FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff`
GROUP BY app_event, LoB
HAVING DATE(MIN(time_stamps)) < DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
ORDER BY strt_time