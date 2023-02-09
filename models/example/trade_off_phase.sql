{{ config(materialized='table') }}

select *
from {{ref('filtered_model_features_dbt')}}
where anomalies = 0
and RMSD_prcnt < 5
