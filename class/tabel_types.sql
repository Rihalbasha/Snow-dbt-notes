



class-16.txt
100%
                            Snowflake Training 
							     Class-16
							------------------------
							Table Types 
							Task 
							
							
Table Types:

There are mainly 4 types of tables (Permanent, Transient, Temp , External )
1) Permanent  - it’s a default type and syntax is Create table <Table Name>   
                 Time travel is 1-90 days
                  File safe is available
                 Until we drop the table data will be available
2) Transient  - It is designed for intermediate or non-critical data 
                       Syntax is Create Transient table <Table Name>
                 Time travel is  0-1 days
                 File safe is not available
                 Until we drop the table data will be available
                 If you don’t want to protect your data we will use this transient
	 Suitable for intermediate or staging tables in ETL pipelines.

3) Temp – It is Designed for short-lived, session-specific data.
   Syntax is Create Temporary Table <Table name>
                 Time travel is 0-1 days
                 File safe is not available
                 Until the session is opened the data will be available
                 	 Automatically dropped at the end of the session or procedure execution.

4) External Table -- Without loading the data into snowflake if you want to see what kind of data 
                                Is there from external sources like AWS S3 , Azure.
CREATE EXTERNAL TABLE <table_name> LOCATION = '<external_stage>' 
•  Time Travel & Failsafe:  Not applicable 
•  Storage Cost:  No Snowflake storage cost (data remains in external stage like S3) 
•  Use Case: Query external data without loading into Snowflake

5) Dynamic tables : 
  Dynamic Tables are Snowflake-managed tables that automatically refresh based on a defined query — 
  How They Work
•	You define a SQL query as the source (usually from staging or raw data).
•	Snowflake automatically keeps the dynamic table updated based on that query.
•	You control how often it should refresh using a TARGET_LAG setting.



 ----Task 
 
 automated schedule process it will run based on the schedule time 
 
 Tools : ctrl+m , tws , apache airflow .....
     5 mins , 10 , 30 mins 
	 
  Alarms -- 6 am 
  credit card bill -- 5th 
  pay slips - 30 th  5000
  
  
  -xyz -- 100 -- 5 people - i want to deleted 
                             
-------------------------SQLS----------------



use vitech_dev_db;


CREATE SCHEMA vitech_dev_db.BRONZE ;

CREATE SCHEMA vitech_dev_db.SILVER ;

CREATE SCHEMA vitech_dev_db.GOLD ;

---------------
CREATE TABLE vitech_dev_db.BRONZE.CUSTOMER (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO vitech_dev_db.BRONZE.CUSTOMER (CID, NAME, EMAIL, ADDRS, STATUS)
VALUES
(111, 'John Smith', 'john.smith@email.com', 'New York, USA', 'ACTIVE'),
(211, 'Mary Johnson', 'mary.johnson@email.com', 'Chicago, USA', 'ACTIVE'),
(311, 'David Brown', 'david.brown@email.com', 'Dallas, USA', 'INACTIVE'),
(411, 'Lisa Wilson', 'lisa.wilson@email.com', 'Seattle, USA', 'ACTIVE'),
(511, 'Michael Davis', 'michael.davis@email.com', 'Boston, USA', 'PENDING');

--------------
CREATE TRANSIENT TABLE vitech_dev_db.BRONZE.CUSTOMER_TRANS (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-----TEMP --

CREATE TEMPORARY TABLE vitech_dev_db.BRONZE.CUSTOMER_TEMP (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SHOW TABLES;


SELECT * FROM vitech_dev_db.BRONZE.CUSTOMER
  UNION ALL 
SELECT * FROM vitech_dev_db.BRONZE.CUSTOMER_TRANS
  UNION ALL
SELECT * FROM vitech_dev_db.BRONZE.CUSTOMER_TEMP


  --------------------------

  -- Create External Table
CREATE OR REPLACE EXTERNAL TABLE VITECH_DEV_DB.BRONZE.LOAN_PAYMENT_EXT (
    LOAN_ID VARCHAR AS (VALUE:C1::VARCHAR)
)
LOCATION = @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE
 FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) 
PATTERN = '.*Loan_payments_data.*[.]csv';


select * from  VITECH_DEV_DB.BRONZE.LOAN_PAYMENT_EXT;

select * from 
VITECH_DEV_DB.SILVER.CUSTOMER;




------------zero copy ----

 create table VITECH_DEV_DB.silver.CUSTOMER  clone VITECH_DEV_DB.bronze.CUSTOMER;


CREATE OR REPLACE DYNAMIC TABLE VITECH_DEV_DB.silver.CUST_dy
TARGET_LAG = '1 Minutes'
WAREHOUSE = COMPUTE_WH
AS
SELECT 
    CID, 
    NAME, 
    EMAIL, 
    STATUS,
    CREATTIMT
    from VITECH_DEV_DB.bronze.CUSTOMER;





select * from 
VITECH_DEV_DB.bronze.CUSTOMER;

 select * from VITECH_DEV_DB.silver.CUST_dy;


 delete from vitech_dev_db.BRONZE.CUSTOMER;


 
select * from 
VITECH_DEV_DB.bronze.CUSTOMER;



delete from VITECH_DEV_DB.bronze.CUSTOMER
 where status = 'INACTIVE' ;

update  VITECH_DEV_DB.bronze.CUSTOMER
   set status = 'INACTIVE'
   where cid = 111
--------------------------------
CREATE OR REPLACE TASK VITECH_DEV_DB.BRONZE.DELETE_INACTIVE_CUSTOMERS
WAREHOUSE = COMPUTE_WH
SCHEDULE = '1 MINUTE'
AS
delete from VITECH_DEV_DB.bronze.CUSTOMER
 where status = 'INACTIVE' ;

 show tasks;


 ALTER TASK VITECH_DEV_DB.BRONZE.DELETE_INACTIVE_CUSTOMERS RESUME;


 ALTER TASK VITECH_DEV_DB.BRONZE.DELETE_INACTIVE_CUSTOMERS suspend;

-- * * * * * -- Every minute
-- */10 * * * * -- Every 10 minutes
-- 0 * * * * -- Every hour
-- 0 0 * * * -- Daily at midnight
-- 0 9 * * MON-FRI -- Weekdays at 9 AM
-- 0 0 1 * * -- First day of month
  
Displaying class-16.txt.




cron exmaples.


Frequency	Schedule Expression	Full Snowflake Clause

Every 5 minutes	*/5 * * * *	SCHEDULE = 'USING CRON */5 * * * * UTC'

Every 15 minutes	*/15 * * * *	SCHEDULE = 'USING CRON */15 * * * * UTC'

Every hour at minute 0	0 * * * *	SCHEDULE = 'USING CRON 0 * * * * UTC'

Daily at Midnight	0 0 * * *	SCHEDULE = 'USING CRON 0 0 * * * UTC'
Daily at 6:00 AM	0 6 * * *	SCHEDULE = 'USING CRON 0 6 * * * UTC'
Mon–Fri at 8:00 AM	0 8 * * 1-5	SCHEDULE = 'USING CRON 0 8 * * 1-5 America/New_York'
Every Sunday at 11:00 PM	0 23 * * 0	SCHEDULE = 'USING CRON 0 23 * * 0 UTC'
1st of every month at 2:00 AM	0 2 1 * *	SCHEDULE = 'USING CRON 0 2 1 * * UTC'