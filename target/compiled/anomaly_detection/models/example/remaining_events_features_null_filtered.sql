

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`filtered_model_features_dbt`
where RMSD_prcnt is not null