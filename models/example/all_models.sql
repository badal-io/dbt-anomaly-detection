{{ config(materialized='table') }}

     select *
     from {{ref('remaining_events_min_RMSD_results')}}
     union all
     select *
     from {{ref('trade_off_max_RMSD_results')}}
     order by app_event, LoB 
