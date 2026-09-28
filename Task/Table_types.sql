

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
  

  ----my practice --


  use HR.PUBLIC;



create schema HR.BRONZE;
create schema HR.SILVER;
create schema HR.GOLD;


CREATE TABLE HR.BRONZE.employees (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO HR.BRONZE.employees (CID, NAME, EMAIL, ADDRS, STATUS)
VALUES
(111, 'John Smith', 'john.smith@email.com', 'New York, USA', 'ACTIVE'),
(211, 'Mary Johnson', 'mary.johnson@email.com', 'Chicago, USA', 'ACTIVE'),
(311, 'David Brown', 'david.brown@email.com', 'Dallas, USA', 'INACTIVE'),
(411, 'Lisa Wilson', 'lisa.wilson@email.com', 'Seattle, USA', 'ACTIVE'),
(511, 'Michael Davis', 'michael.davis@email.com', 'Boston, USA', 'PENDING');
---this is call permenet table ---'



CREATE transient TABLE HR.BRONZE.employees_tran (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);-------transiet table will use "transient" like CREATE transient TABLE HR.BRONZE.employees 



CREATE temporary TABLE HR.BRONZE.employees_temp (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);---- temporary tabel 

show tables;


select *from HR.BRONZE.employees
    union all
select*from HR.BRONZE.employees_tran
    union all
select*from HR.BRONZE.employees_temp----its will use only 1time once if we close the tmp file will delet.



--------zerocopy clonig ----
 ---its will use for move the data or table one database to another data base like bronze to silver silver to gold like that,

 create table HR.silver.employees clone HR.BRONZE.employees;
----for moving data we no need to run the clone each and every time we have dynaminc table .
---every 5mnts it will take the data and its will clone to the req database



--****-dynamic tables*------


----this is the mail will follow 
--------------------------------------------------------------------------------------
---CREATE OR REPLACE DYNAMIC TABLE HR.SILVER.EMP_DY                         ]
  ---TARGET_LAG = '1 minute'                                                ]
  ---WAREHOUSE = COMPUTE_WH                                                 ]
  ---AS                                                                     ]
---SELECT                                                                   ]    
    CID,                                                                    ]   
    NAME,                                                                   ]
    EMAIL,                                                                  ]
    STATUS,                                                                 ]    
    CREATTIMT                                                               ]
--FROM HR.BRONZE.EMPLOYEES;                                                 ]
-------------------------------------------------------------------------------------
CREATE OR REPLACE DYNAMIC TABLE HR.SILVER.EMP_DY
  TARGET_LAG = '1 minute'
  WAREHOUSE = COMPUTE_WH
AS
SELECT
    CID, 
    NAME,
    EMAIL,
    STATUS,
    CREATTIMT
FROM HR.BRONZE.EMPLOYEES;

select*from HR.BRONZE.EMPLOYEES;

select*from HR.SILVER.EMP_DY;

-------*****taks ------------------------------------
-----automatied schedule process it wll run based on the schedulw time
--there ae a  tool 
            --1,ctril+m, tws,apache airflow......
--generaly it will use for credit card bill generating or emply payslip it will generate automatically with out wring the code .


delete from HR.BRONZE.EMPLOYEES
    where status='inactive';-------each and every time we cannot go and run this insted will create taks likebelow

CREATE OR REPLACE TASK HR.BRONZE.DELETE_INACTIVE_EMPLOYEES
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
AS  
  DELETE FROM HR.BRONZE.EMPLOYEES
  WHERE STATUS = 'INACTIVE';
  show tasks;
  --------once you run above query it willgo under pause status we need to resume it for this we need to follow the below query ..
  
-----resume query


alter task HR.BRONZE.DELETE_INACTIVE_EMPLOYEES resume;
--if you need to pause you'ar task will do the below once //only we need to change oneword resume to SUSPEND.....

alter task HR.BRONZE.DELETE_INACTIVE_EMPLOYEES suspend;



update HR.BRONZE.EMPLOYEES
    set status='INACTIVE'
    where cid=511

 select*from HR.BRONZE.EMPLOYEES;


----------insted of runing then taks we have CRON feature there is a few exmaple for those 




            



                
            
