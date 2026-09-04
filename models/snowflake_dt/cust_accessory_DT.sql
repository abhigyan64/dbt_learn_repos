{{ config(
    materialized='dynamic_table',
    snowflake_warehouse='COMPUTE_WH',
    database='SNOWFLAKE_DT',
    schema='TRANSFORM_DT',
    target_lag='3 minutes'
) }}

WITH Cust_Accessory_DT AS
(   SELECT c.cust_id, c.cust_name, c.crid,c.location,c.cust_created,
    a.acc_id, a.acc_category,a.acc_status,a.acc_price,a.acc_count,
        a.acc_price / NULLIF(a.acc_count, 0) AS price_per_accessory
    FROM {{ ref('customer_DT') }} c
    INNER JOIN {{ ref('accessory_DT') }} a ON c.cust_id = a.cust_id
)

SELECT * FROM Cust_Accessory_DT