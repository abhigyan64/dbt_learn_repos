{{ config(
    materialized='dynamic_table',
    snowflake_warehouse='COMPUTE_WH',
    database='SNOWFLAKE_DT',
    schema='TRANSFORM_DT',
    target_lag='DOWNSTREAM'
) }}

WITH Accessory_DT AS
(
    SELECT a.cust_id,a.acc_id,a.acc_category,a.acc_status,a.acc_price,a.acc_count
    FROM SNOWFLAKE_DT.PUBLIC.ACCESSORY_ITEM a

    INNER JOIN
    (SELECT cust_id,acc_id, MAX(acc_price) AS price
        FROM SNOWFLAKE_DT.PUBLIC.ACCESSORY_ITEM
        GROUP BY cust_id, acc_id
    ) max_price
        ON a.cust_id = max_price.cust_id
       AND a.acc_id = max_price.acc_id AND a.acc_price = max_price.price)

SELECT * FROM Accessory_DT