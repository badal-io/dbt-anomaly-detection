{{ config(materialized='table', tags=["data_preparation"]) }}

{% for agg_level in var('anomaly_detection_aggregation_levels') %}

    SELECT "{{agg_level}}hr" AS agg_tag,
        PARSE_TIMESTAMP("%F %H", CONCAT(date_trunc, ' ', CAST(_{{agg_level}}hr_trunc AS STRING))) AS time_stamps,
        {{ var('app_event') }},
        event_count
    FROM (
        SELECT FORMAT_TIMESTAMP("%F", {{ var('collector_tstamp') }}) AS date_trunc,
        FLOOR(CAST(FORMAT_TIMESTAMP("%H", {{ var('collector_tstamp') }}) AS INT64)/{{agg_level}})*{{agg_level}} AS _{{agg_level}}hr_trunc,
        {{ var('app_event') }},
        COUNT({{ var('event_id') }}) AS event_count
        FROM {{ref('raw_data')}}
        GROUP BY
        date_trunc,
        _{{agg_level}}hr_trunc,
        {{ var('app_event') }}
    )


    {% if not loop.last %}
    UNION ALL
    {% else %}

    ORDER BY
    agg_tag,
    time_stamps,
    {{ var('app_event') }}


{% endif %}
{% endfor %}
