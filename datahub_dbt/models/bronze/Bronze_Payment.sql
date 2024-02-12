-- Bronze_Payment.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        pre_hook=[
          "{{ delete_BaseDate(this.schema ,this.table, var('basedate')) }}"
        ]
    )
}}

WITH raw_payments AS (
  SELECT
    basedate,
    id,
    order_id,
    payment_method,
    amount
  FROM {{ source('airflow', 'raw_payments') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT
  basedate AS BaseDate,
  id AS PaymentId,
  order_id AS OrderId,
  payment_method AS PaymentMethod,
  amount AS Amount
FROM raw_payments