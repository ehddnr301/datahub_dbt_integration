-- Bronze_Customer

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        pre_hook=[
          "{{ delete_BaseDate(this.schema ,this.table, var('basedate')) }}"
        ]
    )
}}

WITH raw_customers AS (
  SELECT
    basedate,
    id,
    first_name,
    last_name
  FROM {{ source('airflow', 'raw_customers') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT
  basedate AS BaseDate,
  id AS CustomerId,
  first_name AS FirstName,
  last_name AS LastName
FROM raw_customers