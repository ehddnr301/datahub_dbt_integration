-- Gold_UserInfo.sql

{{
    config(
        materialized='incremental',
        on_schema_change='fail',
        pre_hook=[
          "{{ delete_BaseDate(this.schema ,this.table, var('basedate')) }}"
        ]
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
