


SELECT "4hr" AS agg_tag,
  PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_4hr_trunc AS STRING))) AS time_stamps,
  app_id,
  LoB,
  event_type,
  event_count
FROM (
  SELECT FORMAT_TIMESTAMP("%F", collector_tstamp) AS date_trunc,
    FLOOR(CAST(FORMAT_TIMESTAMP("%H", collector_tstamp) AS INT64)/4)*4 AS _4hr_trunc,
    app_id, 
    LoB,
    event_type,
    COUNT(event_type) AS event_count
  FROM (
    SELECT collector_tstamp, app_id, LoB,
      CASE WHEN event = "unstruct" THEN user_event_name ELSE event
      END AS event_type
    FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_ref_including_LoBs` )
  GROUP BY
    date_trunc,
    _4hr_trunc,
    app_id,
    LoB,
    event_type)

UNION ALL


SELECT "8hr" AS agg_tag,
  PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_8hr_trunc AS STRING))) AS time_stamps,
  app_id,
  LoB,
  event_type,
  event_count
FROM (
  SELECT FORMAT_TIMESTAMP("%F", collector_tstamp) AS date_trunc,
    FLOOR(CAST(FORMAT_TIMESTAMP("%H", collector_tstamp) AS INT64)/8)*8 AS _8hr_trunc,
    app_id, 
    LoB,
    event_type,
    COUNT(event_type) AS event_count
  FROM (
    SELECT collector_tstamp, app_id, LoB,
      CASE WHEN event = "unstruct" THEN user_event_name ELSE event
      END AS event_type
    FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_ref_including_LoBs` )
  GROUP BY
    date_trunc,
    _8hr_trunc,
    app_id,
    LoB,
    event_type)

UNION ALL


SELECT "12hr" AS agg_tag,
  PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_12hr_trunc AS STRING))) AS time_stamps,
  app_id,
  LoB,
  event_type,
  event_count
FROM (
  SELECT FORMAT_TIMESTAMP("%F", collector_tstamp) AS date_trunc,
    FLOOR(CAST(FORMAT_TIMESTAMP("%H", collector_tstamp) AS INT64)/12)*12 AS _12hr_trunc,
    app_id, 
    LoB,
    event_type,
    COUNT(event_type) AS event_count
  FROM (
    SELECT collector_tstamp, app_id, LoB,
      CASE WHEN event = "unstruct" THEN user_event_name ELSE event
      END AS event_type
    FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_ref_including_LoBs` )
  GROUP BY
    date_trunc,
    _12hr_trunc,
    app_id,
    LoB,
    event_type)

UNION ALL


SELECT "24hr" AS agg_tag,
  PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_24hr_trunc AS STRING))) AS time_stamps,
  app_id,
  LoB,
  event_type,
  event_count
FROM (
  SELECT FORMAT_TIMESTAMP("%F", collector_tstamp) AS date_trunc,
    FLOOR(CAST(FORMAT_TIMESTAMP("%H", collector_tstamp) AS INT64)/24)*24 AS _24hr_trunc,
    app_id, 
    LoB,
    event_type,
    COUNT(event_type) AS event_count
  FROM (
    SELECT collector_tstamp, app_id, LoB,
      CASE WHEN event = "unstruct" THEN user_event_name ELSE event
      END AS event_type
    FROM `ld-snowplow`.`dbt_anomaly_detection`.`derived_ref_including_LoBs` )
  GROUP BY
    date_trunc,
    _24hr_trunc,
    app_id,
    LoB,
    event_type)

ORDER BY
  agg_tag,
  time_stamps,
  app_id,
  LoB,
  event_type
