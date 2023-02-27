{{ config(materialized='table', tags=["config_selection"]) }}

select *
from {{ref('nonrecent_configs')}}
where RMSD_prcnt is not null
