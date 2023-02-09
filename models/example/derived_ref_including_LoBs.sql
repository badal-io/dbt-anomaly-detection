{{ config(materialized='table') }}

SELECT collector_tstamp, event, user_event_name, app_id,
    CASE
    WHEN LOWER(app_id) LIKE '%pcexpress%' OR LOWER(app_id) LIKE '%pcx%' THEN "PCX"
    WHEN LOWER(app_id) LIKE '%sdm%' OR LOWER(app_id) LIKE '%beauty%' THEN "SDM Shop"
    WHEN LOWER(app_id) LIKE '%drx%' THEN "SDM Drx" 
    -- WHEN LOWER(page_urlhost) like '%pcoptimum.ca%' and (LOWER(app_id) like '%ios%' or LOWER(app_id) like '%android%') then 'PC Optimum' 
    -- not recommended to use page_urlhost for mobile apps
    WHEN LOWER(app_id) like '%pco%' THEN 'PC Optimum'
    -- WHEN LOWER(page_urlhost) like '%presidentschoice.ca%' THEN 'PC' -- placeholder for after the launch 
    -- WHEN LOWER(page_urlhost) like '%joefresh.com%' and LOWER(app_id) like '%ios%' then 'JF' -- placeholder for after the launch 
    WHEN LOWER(app_id) like '%jf%' THEN 'JF'
    ELSE app_id END AS LoB,
    FROM {{ref('reference_derived')}}