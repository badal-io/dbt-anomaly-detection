{{
    config(
        materialized='incremental',
        unique_key='surrogate_key',
        tags=["config_selection"]
    )
}}

select *,
from {{ref('alerting_predictions')}}
order by time_stamps, app_event