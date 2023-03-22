{{ config(materialized='table', tags=["config_selection"]) }}

with empty_table as (
    select
        cast(null as TIMESTAMP) as time_stamps,
        cast (null as string) app_event,
        cast (null as string) control_config,
        cast(null as int) as anomalies,
        cast(null as float64) as RMSD_prcnt,
        cast(null as float64) as event_count,
        cast(null as float64) as forecast_value,
        cast(null as float64) as lower_bound,
        cast(null as float64) as upper_bound,
        cast(null as float64) as anomaly_probability,
        cast(null as boolean) as is_anomaly,
        cast(null as int) as feedback_flag     
)

select * from empty_table
-- This is a filter so we will never actually insert these values
where 1 = 0