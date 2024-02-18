{{ config(tags = ['test-2']) }}

WITH Gold_KPI AS (
  SELECT
    BaseDate,
    TotalAmount
  FROM {{ ref('Gold_KPI') }}
  WHERE basedate = '{{ var("basedate") }}'
), Silver_Order_Payment AS (
  SELECT
    BaseDate,
    SUM(TotalAmount) AS TotalAmount
  FROM {{ ref('Silver_Order_Payment') }}
  WHERE basedate = '{{ var("basedate") }}'
  GROUP BY BaseDate
), Comparison AS (
  SELECT Gold_KPI.BaseDate,
    Gold_KPI.TotalAmount AS Gold_TotalAmount,
    Silver_Order_Payment.TotalAmount AS Bronze_TotalAmount
  FROM Gold_KPI
  JOIN Silver_Order_Payment
  ON Gold_KPI.BaseDate = Silver_Order_Payment.BaseDate
)

SELECT BaseDate,
  Gold_TotalAmount,
  Bronze_TotalAmount
FROM Comparison
WHERE Gold_TotalAmount != Bronze_TotalAmount
