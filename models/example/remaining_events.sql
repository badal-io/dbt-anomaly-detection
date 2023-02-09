{{ config(materialized='table') }}

select all_events.app_event as app_event, LoB, control_config, anomalies, RMSD_prcnt, neg_lower
from {{ref('ref_distinct_tuples')}} as all_events
left join {{ref('trade_off_max_RMSD_results')}} as results 
on all_events.app_event = results.app_event 
where control_config is null
