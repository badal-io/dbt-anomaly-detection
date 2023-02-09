

  create or replace view `ld-snowplow`.`dbt_anomaly_detection`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `ld-snowplow`.`dbt_anomaly_detection`.`my_first_dbt_model`
where id = 1;

