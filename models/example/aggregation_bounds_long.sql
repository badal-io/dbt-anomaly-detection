{{ config(materialized='table', tags=["data_preparation"]) }}

with temp as (
select quarts, {{ var('app_event') }}, agg_tag from(
select *
from {{ref('aggregation_quartiles_long')}},
unnest(output) as quarts)),

temp_1 as (
select {{ var('app_event') }}, agg_tag, max(quarts) as q3, min(quarts) as q1
from temp
group by {{ var('app_event') }}, agg_tag),

temp_2 as (
select {{ var('app_event') }}, agg_tag, q3, q1, q3-q1 as IQR 
from temp_1)

select {{ var('app_event') }}, agg_tag, (q1-{{ var('IQR_coeff') }}*IQR) as LB, (q3+{{ var('IQR_coeff') }}*IQR) as UB
from temp_2
order by {{ var('app_event') }}, agg_tag