<div style="text-align: left;">
  <div style="display: inline-block; width: 100%;">
    <img src="fish.png" width="1000" style="display: block;">
  </div>
</div>


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

The input field names can also be altered in the dbt_project.yml file. The main three fields are: 1. collector timestamps 2. unique identifier at each timestamp 3. type of user behaviour timeseries data (such as event data, session data, conversion data, etc.). This is the field aggregations will be grouped by. 

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
  start_date: "CURRENT_DATE()"
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
The Interquartile Range method is used here to detect and replace outliers in the train set. These would be beneficiary so that models will not get trained on outlier data. To detect outliers, first, train data is identified by filtering on training intervals (determined by anomaly_detection_forecast_interval in dbt_project.yml). Then, lower and upper bounds for outliers are detected using these formula: 
$Q1 - \text{IQR}_{\text{coeff}} \times \text{IQR}$

$Q3 + \text{IQR}_{\text{coeff}} \times \text{IQR}$

Where Q1 and Q3 represent the first and third quartiles of the data; 
$\text{IQR} = Q3 - Q1$;
$\text{IQR}_{\text{coeff}}$ determines how wide the interval between the bounds should be. The higher the $\text{IQR}_{\text{coeff}}$, the wider the interval will be, thus the less sensitive the model will be to outliers in the train set. Outliers in the train set will be replaced by the bounds. 

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
In this package, created models are various in terms of training intervals and levels of granularity. The threshold parameter in the forecasts determine the sensitivity of each timestamp data to getting detected as an anomaly. The higher the threshold, the less sensitive the model will be to anomalies. All configurations of model creation and forecasts are as follows:

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

#### reset_forecasts:
Sometimes, the lower bounds of the forecasts hit negative values. This model is created to reset those negative values to a small positive count (determined by neg_lower_bound_reset). In some scenarios, no matter how high the forecast probabality threshold is tuned, the user will still get some false anomalies. The bounds_coeff variable determines the coefficient by which the user can widen the intervals between the bounds. It can be set as 1 in cases where there is no need to tweak the predicted bounds. 

``` yml
vars:
  neg_lower_bound_reset: 2
  bounds_coeff: 1.3
```
#### nonrecent_events:
This model is created to filter on recently released data, which may have unstable trends or patterns that can make forecasts unreliable. Models are filtered on recent data by configuring recent_event_cutoff (days). 

``` yml
vars:
  recent_event_cutoff: 30
```

#### all_configs:
all_configs identifies two features from the prediction set of each created ARIMA model: 1. number of anomalies 2. RMSD (Root Mean Square Deviation) of the predicted bounds 
The ultimate goal is to dynamically choose/update the best model/config for each user behaviour data type (e.g. event data). The best model in this package is defined as the one which produces minimum number of anomalies in the prediction set. In cases where more than one model has the same minimal number of anomalies for a specifc user behaviour data type, the one with minimum RMSD is chosen. RMSD determines how wide/loose the interval between the predicted bounds are, and is a good indicator of the quality/practicality of the models. 

#### nonrecent_configs, filtered_nonrecent_configs:
Filters the configs on recent data, and any models generating NULL RMSDs. 

#### min_anomalies, min_anomalies_configs
Determines the config(s) with minimal anomalies in prediction set for each user behaviour data type (e.g. event data)

#### min_RMSD, control_table
Determines the config with minimal RMSD of the predicted bounds for each user behaviour data type. This is especially helpful when there is more than one model chosen for each user behaviour data. This provides us with a control table consisting of the data types, chosen configs (or control configs) and the corresponding features of the control config (anomalies and RMSD) 

#### alerting base
This model is the product of the join of control_table against the original forecasts, and results in the optimal forecasts for each user behaviour data type. Each timestamp data is flagged either as an anomalous or non-anomalous in this model.

#### daily_alerts
Filters only on anomalies of the day, and can be used for alerting purposes. 
