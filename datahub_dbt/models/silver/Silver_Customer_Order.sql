-- Silver_Customer_Order.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
    )
}}

WITH Bronze_Customer AS (
  SELECT
    BaseDate,
    CustomerId,
    FirstName,
    LastName
  FROM {{ ref ('Bronze_Customer') }}
  WHERE basedate = '{{ var("basedate") }}'
), Bronze_Order AS (
  SELECT
    BaseDate,
    OrderId,
    UserId,
    Status
  FROM {{ ref ('Bronze_Order') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT BO.BaseDate
, BC.CustomerId
, BC.FirstName
, BC.LastName
, BO.OrderId
, BO.Status
FROM Bronze_Customer AS BC
JOIN Bronze_Order AS BO
ON BC.BaseDate = BO.BaseDate
AND BC.CustomerId = BO.UserId