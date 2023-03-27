{{ config(materialized='table', tags=["config_selection"]) }}

SELECT MIN(time_stamps) AS strt_time, {{ var('app_event') }}
FROM {{ref('aggregations_cutoff')}}
GROUP BY {{ var('app_event') }}
HAVING DATE(MIN(time_stamps)) < DATE_SUB(PARSE_DATE("%Y-%m-%d", "{{ var('start_date') }}"), INTERVAL {{ var('recent_event_cutoff') }} DAY)
ORDER BY strt_time
