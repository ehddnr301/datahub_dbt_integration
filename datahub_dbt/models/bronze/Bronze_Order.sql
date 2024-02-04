-- Bronze_Order

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
    )
}}

WITH raw_orders AS (
  SELECT
    basedate,
    id,
    user_id,
    status
  FROM {{ source('linked_server', 'raw_orders') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT
  basedate AS BaseDate,
  id AS OrderId,
  user_id AS UserId,
  status AS Status
FROM raw_orders