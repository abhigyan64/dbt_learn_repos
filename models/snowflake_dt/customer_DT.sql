{{ config(
    materialized='dynamic_table',
    snowflake_warehouse='COMPUTE_WH',
    database='SNOWFLAKE_DT',
    schema='TRANSFORM_DT',
    target_lag='DOWNSTREAM'
) }}

WITH Customers_DT AS
(
    SELECT cust_id, cust_name, total_outstanding_amt, CRID, location, CUST_CREATED
    FROM SNOWFLAKE_DT.PUBLIC.CUSTOMER
    QUALIFY ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY CUST_CREATED DESC) = 1
)

SELECT * FROM Customers_DT