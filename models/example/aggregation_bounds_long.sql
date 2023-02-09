{{ config(materialized='table') }}

with temp as (
select quarts, app_event, agg_tag from(
select *
from {{ref('aggregation_quartiles_long')}},
unnest(output) as quarts)),

temp_1 as (
select app_event, agg_tag, max(quarts) as q3, min(quarts) as q1
from temp
group by app_event, agg_tag),

temp_2 as (
select app_event, agg_tag, q3, q1, q3-q1 as IQR 
from temp_1)

select app_event, agg_tag, (q1-4.5*IQR) as LB, (q3+4.5*IQR) as UB
from temp_2
order by app_event, agg_tag