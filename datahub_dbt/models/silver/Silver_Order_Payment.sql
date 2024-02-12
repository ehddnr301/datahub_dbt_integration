-- Silver_Order_Payment.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        pre_hook=[
          "{{ delete_BaseDate(this.schema ,this.table, var('basedate')) }}"
        ]
    )
}}

WITH Bronze_Order AS (
  SELECT
    BaseDate,
    OrderId,
    UserId,
    Status
  FROM {{ ref('Bronze_Order') }}
  WHERE basedate = '{{ var("basedate") }}'
), Bronze_Payment AS (
  SELECT
    BaseDate,
    OrderId,
    PaymentId,
    PaymentMethod,
    Amount
  FROM {{ ref('Bronze_Payment') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT BO.BaseDate
, BO.UserId
, BO.OrderId
, BO.Status
, BP.PaymentMethod
, SUM(BP.Amount) AS TotalAmount
FROM Bronze_Order AS BO
JOIN Bronze_Payment AS BP
ON BO.BaseDate = BP.BaseDate
AND BO.OrderId = BP.OrderId
GROUP BY BO.BaseDate, BO.UserId, BO.OrderId, BO.Status, BP.PaymentMethod