{{ config(materialized='table') }}

select *
from {{ref('remaining_events_features')}}
where RMSD_prcnt is not null
