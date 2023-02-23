{{ config(materialized='table', tags=["data_preparation"]) }}


{% for agg_level in var('anomaly_detection_aggregation_levels') %}


 SELECT "{{agg_level}}hr" AS agg_tag,
 PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_{{agg_level}}hr_trunc AS STRING))) AS time_stamps,
 app_id,
 event_type,
 event_count
 FROM (


   SELECT FORMAT_TIMESTAMP("%F", collector_tstamp) AS date_trunc,
   FLOOR(CAST(FORMAT_TIMESTAMP("%H", collector_tstamp) AS INT64)/{{agg_level}})*{{agg_level}} AS _{{agg_level}}hr_trunc,
   app_id,
   event_type,
   COUNT(event_id) AS event_count
   FROM {{ref('reference_derived')}}
   GROUP BY
   date_trunc,
   _{{agg_level}}hr_trunc,
   app_id,
   event_type)


{% if not loop.last %}
UNION ALL
{% else %}


ORDER BY
agg_tag,
time_stamps,
app_id,
event_type


{% endif %}
{% endfor %}
