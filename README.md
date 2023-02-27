Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

``` yml
vars:
  anomaly_detection_aggregation_levels: [4, 8, 12, 24]
  anomaly_detection_prob_thresholds : [0.9999, 0.999999]
  anomaly_detection_horizon: 120
  anomaly_detection_forecast_interval: 10
  anomaly_detection_holiday_region: "CA"
  data_interval: 90
```

``` dbt
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
