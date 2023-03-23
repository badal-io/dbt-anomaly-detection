{{ config(materialized='ephemeral', tags=["data_preparation"]) }}

select   ARRAY(SELECT x FROM UNNEST(output) AS x WITH OFFSET
  WHERE OFFSET BETWEEN 1 AND ARRAY_LENGTH(output) - 2) as output, 
  {{ var('app_event') }}, agg_tag
  from (
select APPROX_QUANTILES(event_count, 4) AS output, {{ var('app_event') }}
, agg_tag
from {{ref('train_data')}}
group by {{ var('app_event') }}, agg_tag
order by {{ var('app_event') }}, agg_tag )