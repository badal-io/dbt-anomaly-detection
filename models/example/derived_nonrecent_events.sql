{{ config(materialized='table', tags=["config_selection"]) }}

SELECT MIN(time_stamps) AS strt_time, app_event
FROM {{ref('all_agg_derived_cutoff')}}
GROUP BY app_event
HAVING DATE(MIN(time_stamps)) < DATE_SUB({{ var('start_date') }}, INTERVAL {{ var('recent_event_cutoff') }} DAY)
ORDER BY strt_time
