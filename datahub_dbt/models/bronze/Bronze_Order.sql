-- Bronze_Order

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        pre_hook=[
          "{{ delete_BaseDate(this.schema ,this.table, var('basedate')) }}"
        ]
    )
}}

WITH raw_orders AS (
  SELECT
    basedate,
    id,
    user_id,
    status
  FROM {{ source('airflow', 'raw_orders') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT
  basedate AS BaseDate,
  id AS OrderId,
  user_id AS UserId,
  status AS Status
FROM raw_orders