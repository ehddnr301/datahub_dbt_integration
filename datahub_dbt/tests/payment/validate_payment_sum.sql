-- tests/payment/validate_payment_sum.sql

WITH Gold_KPI AS (
  SELECT
    BaseDate,
    TotalAmount
  FROM {{ ref('Gold_KPI') }}
  WHERE basedate = '{{ var("basedate") }}'
), Bronze_Payment AS (
  SELECT
    BaseDate,
    SUM(Amount) AS TotalAmount
  FROM {{ ref('Bronze_Payment') }}
  WHERE basedate = '{{ var("basedate") }}'
  GROUP BY BaseDate
), Comparison AS (
  SELECT Gold_KPI.BaseDate,
    Gold_KPI.TotalAmount AS Gold_TotalAmount,
    Bronze_Payment.TotalAmount AS Bronze_TotalAmount
  FROM Gold_KPI
  JOIN Bronze_Payment
  ON Gold_KPI.BaseDate = Bronze_Payment.BaseDate
)

SELECT BaseDate,
  Gold_TotalAmount,
  Bronze_TotalAmount
FROM Comparison
WHERE Gold_TotalAmount != Bronze_TotalAmount
