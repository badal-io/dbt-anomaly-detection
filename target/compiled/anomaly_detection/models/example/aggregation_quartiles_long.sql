

select   ARRAY(SELECT x FROM UNNEST(output) AS x WITH OFFSET
  WHERE OFFSET BETWEEN 1 AND ARRAY_LENGTH(output) - 2) as output, 
  app_event, agg_tag
  from (
select APPROX_QUANTILES(event_count, 4) AS output, app_event
, agg_tag
from `ld-snowplow`.`dbt_anomaly_detection`.`all_agg_derived_cutoff_long`
group by app_event, agg_tag
order by app_event, agg_tag )