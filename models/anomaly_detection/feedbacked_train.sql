{{ config(materialized='table', tags=["modelling"]) }}

  SELECT
    new_train_set.time_stamps AS time_stamps,
    new_train_set.app_event AS app_event,
    new_train_set.agg_tag AS agg_tag,
    CASE
      WHEN historical_feedback.feedback_flag = 1 THEN historical_feedback.forecast_value
    ELSE
    new_train_set.event_count
  END
    AS event_count
  FROM
    {{ref('train_data')}} AS new_train_set
  LEFT JOIN
    {{ref('alerting_feedback')}} AS historical_feedback
  ON
    new_train_set.time_stamps = historical_feedback.time_stamps
    AND new_train_set.app_event = historical_feedback.app_event 

-- this model updates the train set using the stored predictions and flags feedbacked by the end user through the Looker UI
-- the alerting_feedback table is therefore ceated through the cloud functions and not in dbt lineage
