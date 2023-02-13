{{ config(materialized='table', tags=["config_selection"]) }}

select *
from {{ref('filtered_model_features_dbt')}}
where RMSD_prcnt is not null
