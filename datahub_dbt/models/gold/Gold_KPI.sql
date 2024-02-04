-- Gold_UserInfo.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
    )
}}

WITH Gold_UserInfo AS (
  SELECT
    BaseDate,
    TotalAmount
  FROM {{ ref('Gold_UserInfo') }}
  WHERE basedate = '{{ var("basedate") }}'
)

SELECT BaseDate,
    SUM(TotalAmount) AS TotalAmount
FROM Gold_UserInfo
GROUP BY BaseDate
