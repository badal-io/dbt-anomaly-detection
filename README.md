
### Anomaly detection on timeseries user behaviour data

Anomaly detection in user behavior data helps in identifying any abnormal or unexpected behavior patterns. This information can be used to improve data quality and resolve problems before they escalate. The goal of this package is to develop an anomaly detection framework for user behavior time-series data that is able to adapt to changing patterns and produce minimum false alerts. The framework uses BigQuery ML ARIMA Plus which takes trends and seasonality of data into account.


### How to get started 

Using this package is pretty straightforward. After getting dbt installed on your machine and connected to your BigQuery instance, you need to install the package running dbt deps command. 

The configurations of the sources.yml file can be changed as follows: 

``` yml
  # sources vars
  source_table: sample_table_final
  source_name: sampled_data
```

The input field names can also be altered in the dbt_project.yml file. The main three fields are: 1. collector timestamps 2. unique identifier at each timestamp 3. types of user behaviour timeseries data (such as event data, session data, conversion data, etc.)

``` yml
  # input fields
  collector_tstamp: collector_tstamp #collector timestamps
  event_id: event_id #unique identifiers
  app_event: app_event #aggregation field
```

### Overview of dbt Models 

#### raw_data: 
This model filters the data on the desired period of time. The period can be configured by the variables in the dbt_project.yml file as follows:

``` yml
vars:
  data_interval: 90
  start_date: "CURRENT_DATE()
```

#### aggregations:
This model aggregates the count of unique identifiers within different levels of granularity. These levels of granularity can be configured in the dbt_project.yml file as follows:

``` yml
vars:
  anomaly_detection_aggregation_levels: [4, 8, 12, 24]
```

#### cutoff_dates, aggregations_cutoff:
The purpose of these models is to reset aggregated counts to the date when the counts surpass a minimum cutoff value. This can be helpful in scenarios where an event has not been fully released for instance. The cutoff count can be configured as follows:

``` yml
vars:
  cutoff_count: 50
```

#### train_data, IQR_quartiles, IQR_bounds, IQR_outliers:
The Interquartile Range method is used here to detect and replace outliers in the train set. These would be beneficiary so that models will not get trained on outlier data. To detect outliers, first, train data is identified by filtering on training intervals (determined by anomaly_detection_forecast_interval in dbt_project.yml). Then, lower and upper bounds for outliers are detected using these formula: Q1 – IQR_coeff * IQR and Q3 + IQR_coeff * IQR, where Q1 and Q3 represent the first and third quartiles of the data; IQR = Q3 - Q1; IQR_coeff determines how wide the interval between the bounds should be. The higher the IQR_coeff, the wider the interval will be, thus the less sensitive the model will be to outliers in the train set. Outliers in the train set will be replaced by the bounds. 

``` yml
vars:
   IQR_coeff: 4.5
   anomaly_detection_forecast_interval: 10
```

#### forecasts 
forecasts has a perhook for model creation as follows:

``` yml
models:
  anomaly_detection:
    +materialized: view
    anomaly_detection:
      forecasts:
        +pre-hook:
          - "{{ create_models() }}"
```

Therefore, first the create_models() macro runs which creates all ARIMA plus models. This if followed by forecasts on the prediction sets. 
In this package, created models are various in terms of training intervals and levels of granularity. The threshold parameter in the forecasts determine the sensitivity of each timestamp data to getting detected as an anomaly. The higher the threshold, the less sensitive the model will be to anomalies. All configurations of model creation and forecasts is as follows:

``` yml
vars:
  anomaly_detection_prob_thresholds : [0.9999, 0.999999]
  anomaly_detection_horizon: 120
  anomaly_detection_forecast_interval: 10
  anomaly_detection_holiday_region: "CA"
  
  models:
    1mon_8hr:
      period: "8hr"
      train_interval: 60
```
