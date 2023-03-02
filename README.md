
### Anomaly detection on timeseries user behaviour data

Anomaly detection in user behavior data helps in identifying any abnormal or unexpected behavior patterns. This information can be used to improve data quality and resolve problems before they escalate. The goal of this package is to develop an anomaly detection framework for user behavior time-series data that is able to adapt to changing patterns and produce minimum false alerts. The framework uses BigQuery ML ARIMA Plus which takes trends and seasonality of data into account.


### How to get started 

Using this package is pretty straightforward. After getting dbt installed on your machine and connected to your BigQuery instance, you need to install the package and run dbt deps to make sure it is installed. 

### Overview of dbt Models 

#### raw_data: 
This model filters the data on the desired period of time.

#### aggregations:
This model aggregates the count of unique identifiers within different levels of granularity. These levels of granularity can be configured in the dbt_project.yml file as follows:

``` yml
vars:
  anomaly_detection_aggregation_levels: [4, 8, 12, 24]
```

#### cutoff_dates, aggregations_cutoff:
The purpose of these models is to reset aggregated counts to the date when the counts surpass a minimum cutoff value. This can be helpful in scenarios where an event has not been fully released. The cutoff count can be configured as follows:

``` yml
vars:
  cutoff_count: 50
```

#### train_data, IQR_quartiles, IQR_bounds, IQR_outliers:
The Interquartile Range method is used here to detect and replace outliers in the train set. These would be beneficiary so that models will not get trained on outlier data. To detect outliers, first, train data is identified by filtering on training intervals. Then, lower and upper bounds for outliers are detected using these formula: Q1 – IQR_coeff * IQR and Q3 + IQR_coeff * IQR, where Q1 and Q3 represent the first and third quartiles of the data; IQR = Q3 - Q1; IQR_coeff determines how wide the interval between the bounds are. The higher the IQR_coeff, the wider the interval will be, thus the less sensitive the model will be to outliers in the train set. Outliers in the train set will be replaced by the bounds. 

``` yml
vars:
   IQR_coeff: 4.5
```
