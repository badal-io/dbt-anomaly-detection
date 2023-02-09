

    create or replace model `ld-snowplow`.`dbt_anomaly_detection`.`derived_models_05mon_24hr`
    options(MODEL_TYPE="ARIMA_PLUS",TIME_SERIES_TIMESTAMP_COL="time_stamps",TIME_SERIES_DATA_COL="event_count",TIME_SERIES_ID_COL=['app_event', 'LoB', 'agg_tag'],HORIZON=120,HOLIDAY_REGION="CA")as (
        
-- the highest horizon required for ml.detect func not to pass nulls 
-- horizon = 30 would result in 6 nulls for 4hr agg, 3 nulls for 8hr agg, 2 nulls for 12hr agg and 1 null for 24hr agg. 
WITH date_control as (
SELECT 
CURRENT_DATE() AS cur_date
),

interval_control as (
SELECT 
30 AS training_interval -- SET TRAINING INTERVAL HERE for PROD
),

lookback as (
SELECT 
15 AS lookback_interval -- SET TRAINING INTERVAL HERE for PROD
FROM interval_control
)
--- Code above is for dev/ local only. Code below is for model.
SELECT
  time_stamps,
  event_count,
  app_event,
  LoB,
  agg_tag
FROM
  `ld-snowplow`.`dbt_anomaly_detection`.`aggregation_outliers_short`
WHERE
  DATE(time_stamps) >= DATE_SUB(                      --- training on sep 17 to sep 20 if dev 
    (SELECT cur_date FROM date_control)
  , INTERVAL (SELECT training_interval FROM interval_control) 
  DAY) AND DATE(time_stamps) < DATE_SUB(
    (SELECT cur_date FROM date_control)
    , INTERVAL (SELECT lookback_interval from lookback)
    DAY)
  AND agg_tag = "24hr"
  -- AND DATE(time_stamps) NOT BETWEEN "2022-11-23" AND "2022-11-30" 
  -- black friday surges affect the distribution of the training set and therefore, will affect the forecast in an unprecented way. 
  -- thus, excluding the last week of November from the train set
    );
    