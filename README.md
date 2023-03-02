
### Anomaly detection on timeseries user behaviour data

Anomaly detection in user behavior data helps in identifying any abnormal or unexpected behavior patterns. This information can be used to improve data quality and resolve problems before they escalate. The goal of this package is to develop an anomaly detection framework for user behavior time-series data that is able to adapt to changing patterns and produce minimum false alerts. The framework uses BigQuery ML ARIMA Plus which takes trends and seasonality of data into account.


### How to get started 

Using this package is pretty straightforward. After getting dbt installed on your machine and connected to your BigQuery instance, you need to install the package and run dbt deps to make sure it is installed. 

### Overview of dbt Models 

raw_data: 
This model filters the data on the desired period of time.

aggregations:
This model aggregates the count of unique identifiers within different levels of granularity. These levels of granularity can be configured in the dbt_project.yml file as follows:

``` yml
vars:
  anomaly_detection_aggregation_levels: [4, 8, 12, 24]
```

cutoff_dates, aggregations_cutoff:
The purpose of these models is to reset aggregated counts to the date when the counts surpass a minimum cutoff value. This can be helpful in scenarios where an event has not been fully released. The cutoff count can be configured as follows:

``` yml
vars:
  cutoff_count: 50
```





``` sql
{{ config(materialized='table', tags=["data_preparation"]) }}

with bounds_agg as (
select time_stamps, bounds.{{ var('app_event') }} as {{ var('app_event') }}, bounds.agg_tag as agg_tag, event_count, LB, UB
from {{ref('IQR_bounds')}} as bounds
inner join {{ref('train_data')}} as aggs
on bounds.{{ var('app_event') }} = aggs.{{ var('app_event') }}
and bounds.agg_tag = aggs.agg_tag
order by bounds.{{ var('app_event') }}, bounds.agg_tag)

select time_stamps, {{ var('app_event') }}, agg_tag,
case when event_count > UB then UB
when event_count < LB then LB
else event_count
end as event_count
from bounds_agg
order by {{ var('app_event') }}, agg_tag, time_stamps
```
