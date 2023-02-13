
SELECT collector_tstamp, event, user_event_name, app_id
FROM `ld-snowplow`.`dbt_rhashemi`.`web_purchase_exported`
WHERE DATE(collector_tstamp) >= DATE_SUB("2023-02-09", INTERVAL 90 DAY) AND DATE(collector_tstamp) < "2023-02-09"

UNION ALL

SELECT collector_tstamp, event, user_event_name, app_id
FROM `ld-snowplow`.`dbt_rhashemi`.`pco_web_apply_filter_exported`
WHERE DATE(collector_tstamp) >= DATE_SUB("2023-02-09", INTERVAL 90 DAY) AND DATE(collector_tstamp) < "2023-02-09"