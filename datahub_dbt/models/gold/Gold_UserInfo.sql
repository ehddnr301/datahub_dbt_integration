-- Gold_UserInfo.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
    )
}}

WITH Silver_Customer_Order AS (
  SELECT
    BaseDate,
    CustomerId,
    FirstName,
    LastName,
    OrderId,
    Status
  FROM {{ ref('Silver_Customer_Order') }}
  WHERE basedate = '{{ var("basedate") }}'
), Silver_Order_Payment AS (
  SELECT
    BaseDate,
    UserId,
    OrderId,
    Status,
    PaymentMethod,
    TotalAmount
  FROM {{ ref('Silver_Order_Payment') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT SCO.BaseDate
, SCO.CustomerId
, SCO.FirstName
, SCO.LastName
, SCO.OrderId
, SCO.Status
, SOP.PaymentMethod
, SOP.TotalAmount
FROM Silver_Customer_Order AS SCO
JOIN Silver_Order_Payment AS SOP
ON SCO.BaseDate = SOP.BaseDate
AND SCO.OrderId = SOP.OrderId
AND SCO.CustomerId = SOP.UserId