{{
    config(
        materialized='incremental',
        unique_key='unique_id',
        tags=["config_selection"]
    )
}}

select CONCAT (time_stamps, '_', app_event) as unique_id, *
from {{ref('alerting_predictions')}}
order by time_stamps, app_event



