

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
where anomalies = 0
and RMSD_prcnt < 5