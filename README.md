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

``` jinja
vars:
  anomaly_detection_aggregation_levels: [4, 8, 12, 24]
  anomaly_detection_prob_thresholds : [0.9999, 0.999999]
  anomaly_detection_horizon: 120
  anomaly_detection_forecast_interval: 10
  anomaly_detection_holiday_region: "CA"
  data_interval: 90
```
