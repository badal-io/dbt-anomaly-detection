{{ config(materialized='table') }}

select remaning_events.app_event as app_event, all_features.LoB as LoB, all_features.control_config as control_config, all_features.anomalies as anomalies, all_features.RMSD_prcnt as RMSD_prcnt, all_features.neg_lower as neg_lower
from {{ref('remaining_events')}} as remaning_events
inner join {{ref('filtered_model_features_dbt')}} as all_features
on remaning_events.app_event = all_features.app_event
