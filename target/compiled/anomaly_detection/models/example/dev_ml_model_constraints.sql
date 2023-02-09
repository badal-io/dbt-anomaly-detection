
-- This materialization is used to constrain the model during dev due to lack of data. Current Date is set to latest_date

WITH latest_earliest AS (
SELECT 
EXTRACT(DATE FROM (SELECT MAX(time_stamps) FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived`)) AS latest_date, -- always sep 21
EXTRACT(DATE FROM (SELECT MIN(time_stamps) FROM `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived`)) AS earliest_date -- always sep 17
)
SELECT *,
-- CASE WHEN DATE_DIFF(latest_date, earliest_date, DAY) >= 35 
-- THEN 35 
     DATE_DIFF(latest_date, earliest_date, DAY) -- always 4
     AS training_interval
FROM latest_earliest