


---views will not save it will use for one time watch 
---views are 3types 
    ---1.standard view
    ----2.Secure view
    ----3.Materializedview


select*from HR.SILVER.EMPLOYEES;



create or replace view HR.GOLD.EMPLOYEES_V
as
select*from HR.SILVER.EMPLOYEES

select*from HR.GOLD.EMPLOYEES_V;

show views;


--------creatig secure view----

create or replace secure view HR.GOLD.EMPLOYEES_SV
as
select 
    CID,
    NAME,
    EMAIL,
    status from HR.SILVER.EMPLOYEES;

---meterialized view------

SELECT TOP 5* FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;-----for runing this it willtake more time..for this we have query below.it will reduse the runing time.


CREATE OR REPLACE MATERIALIZED VIEW HR.GOLD.ORDERS_M
AS
SELECT 
    O_CUSTKEY, 
    MAX(O_TOTALPRICE) AS MAX_ORDER_PRICE,
    COUNT(O_CLERK) AS CNT  
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS
GROUP BY O_CUSTKEY;

SELECT * FROM HR.GOLD.ORDERS_M;----this above query will follow for the short runing time this link will provide the users for using 
