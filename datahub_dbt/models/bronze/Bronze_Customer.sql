-- Bronze_Customer

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
    )
}}

WITH raw_customers AS (
  SELECT
    basedate,
    id,
    first_name,
    last_name
  FROM {{ source('linked_server', 'raw_customers') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT
  basedate AS BaseDate,
  id AS CustomerId,
  first_name AS FirstName,
  last_name AS LastName
FROM raw_customers