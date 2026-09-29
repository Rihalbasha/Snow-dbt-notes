


class-18.txt
100%
                           Snowflake Training 
							     Class-18
							------------------------
							Views 
							diff types Cache
							
							
In Snowflake, views are used to simplify complex queries, enforce security, and improve performance. Based on my experience, there are three main types of views:
1. Standard View
•	Definition: View is an virtual table  built on top of a query. It doesn’t store data — it runs the underlying query every time it's accessed.
•	Use Case: Simplifies complex joins or filters for reporting and analytics.
2. Secure View
•	Definition: Similar to a standard view but does not expose underlying table metadata to the querying user.
•	Use Case: Ideal for data masking, multi-tenant environments, or external data sharing.
•	Security: Enforces row-level and column-level security.
3. Materialized View
•	Definition: Stores precomputed results of a query. Unlike standard views, it physically stores data and updates automatically.
•	Use Case: Great for frequently accessed aggregations or dashboards where performance is critical.
•	Performance: Faster than regular views; reduces compute cost.

OR 

1. Views
•	Logical representation of a query — no data stored physically.
•	Data is always current — reflects underlying table changes.
•	Quick to create & can be queried like a normal table.
•	Performance depends on the underlying query; it may be slow for complex aggregations.
Syntax: 
CREATE OR REPLACE VIEW vw_customer AS
SELECT customer_id, name, city
FROM customer
WHERE is_active = TRUE;

	Logical query; data not stored.
	Reflects current underlying table data.

2. Secure Views
•	Same as regular views but with enhanced security.
•	Hides the underlying SQL logic from users.
•	Only users with proper privileges can query the view.
•	Supports row-level and column-level security indirectly.
•	Prevents sensitive business logic exposure while sharing data.
Syntax:
CREATE OR REPLACE SECURE VIEW sec_vw_customer AS
SELECT customer_id, name, city
FROM customer
WHERE is_active = TRUE;

3. Materialized Views
•	Stores the result set physically, unlike normal views.
•	Improves performance for frequently queried aggregations or joins.
•	Automatically maintained in the background (incremental refresh).
•	Consumes storage and may require compute for refresh.
•	Best for tables with infrequent updates but high read frequency.
Syntax:
CREATE OR REPLACE MATERIALIZED VIEW mv_customer_summary AS
SELECT city, COUNT(*) AS total_customers
FROM customer
GROUP BY city;

	Stores the result physically.
	Improves performance for frequent queries or aggregations.
	Automatically refreshed incrementally by Snowflake.

-----------------
1. Result Cache
•	What it is: Stores the results of queries that have already been executed.
•	Duration: Cached for 24 hours.
•	When it applies: If the same query is run again and the underlying data hasn’t changed, Snowflake returns the result instantly from cache.
•	Benefit: Zero compute cost for repeated queries.
2. Data Cache (Local Disk Cache)
•	What it is: Stores data on the local disk of the virtual warehouse after it's read from cloud storage.
•	When it applies: If the same data is accessed again by the same warehouse, it’s read from local cache instead of cloud storage.
•	Benefit: Faster access and reduced I/O cost.
3. Metadata Cache
•	What it is: Stores metadata about tables, columns, micro-partitions, etc.
•	Used by: The query optimizer to determine which partitions to scan.
•	Benefit: Helps Snowflake prune unnecessary partitions, improving performance.


---------------------
SQLS:

select * from VITECH_DEV_DB.SILVER.CUSTOMER;



CREATE OR REPLACE VIEW VITECH_DEV_DB.GOLD.CUSTOMER_V
AS
select * from VITECH_DEV_DB.SILVER.CUSTOMER

DELETE FROM VITECH_DEV_DB.SILVER.CUSTOMER
 WHERE CID IN (1,2)

SELECT * FROM VITECH_DEV_DB.GOLD.CUSTOMER_V;


--hr -- EMPLOYEE DEPART

SHOW VIEWS 

CREATE OR REPLACE VIEW VITECH_DEV_DB.GOLD.CUSTOMER_V
AS
select CID,
     NAME,
     EMAIL,
     STATUS from VITECH_DEV_DB.SILVER.CUSTOMER ;


CREATE OR REPLACE SECURE VIEW VITECH_DEV_DB.GOLD.CUSTOMER_S
AS
select CID,
     NAME,
     EMAIL,
     STATUS from VITECH_DEV_DB.SILVER.CUSTOMER ;



CREATE OR REPLACE MATERIALIZED  VIEW VITECH_DEV_DB.GOLD.CUSTOMER_M
AS
select CID,
     NAME,
     EMAIL,
     STATUS from VITECH_DEV_DB.SILVER.CUSTOMER ;

SELECT TOP 5* FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;


CREATE OR REPLACE MATERIALIZED  VIEW VITECH_DEV_DB.GOLD.ORDERS_M
AS
SELECT O_CUSTKEY, 
        MAX(O_TOTALPRICE) AS MAX_ORDER_PRICE ,
        COUNT(O_CLERK)  AS CNT  FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS
        GROUP BY O_CUSTKEY
;

SELECT * FROM VITECH_DEV_DB.GOLD.ORDERS_M;

------------------------------------


SELECT * FROM HR.VIT.emps  ;



select * from hr.vit.emps  where salary > 20000 ;


select count(*)  from hr.vit.emps ;

describe table hr.vit.emps ;








Displaying class-18.txt.