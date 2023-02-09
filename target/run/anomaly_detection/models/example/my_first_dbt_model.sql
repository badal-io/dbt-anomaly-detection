

  create or replace table `ld-snowplow`.`dbt_anomaly_detection`.`my_first_dbt_model`
  
  
  OPTIONS()
  as (
    /*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/



SELECT *
FROM `ld-snowplow`.`dbt_rhashemi`.`aggregations_main`

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
  );
  