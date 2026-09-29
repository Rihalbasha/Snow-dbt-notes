


class-19.txt
100%
                             Snowflake Training 
							     Class-19
							------------------------
							Data Masking 
							Data sharing 
							https://youtu.be/iSNOo5lqJ24
							
							
1234-5678-7678-7889

XXXX-XXXX-XXXX-7889 


Data Masking : in order to protect the sensitive data we are going to use the data masking 

PII -- email , phone , debit card , credit etc ....

Abhinash --  Abh******** 


1. we are gonna create 2 roles 
2. data mask / data full    


Task--
create a policy and apply for the phone the output as below

262-665-9168 

XXX-XXX-9168 


Data sharing :   

phone -- files   --->  data to another user --> 
                                     bluetooth , whats app ,gmail ,insta ....
									 
									 
{"accountName":"VITECH_SNOW_ACCOUNT","accountLocator":"RQ89337","url":"https://vwiuzsl-vitech_snow_account.snowflakecomputing.com","accountLocatorUrl":"https://rq89337.ap-southeast-1.snowflakecomputing.com"}
									 
SQLS:
------------------
create database DEMO_DB;

USE DEMO_DB;
USE ROLE ACCOUNTADMIN;


-- Prepare table --
create or replace table customers(
  id number,
  full_name varchar, 
  email varchar,
  phone varchar,
  spent number,
  create_date DATE DEFAULT CURRENT_DATE);

-- insert values in table --
insert into customers (id, full_name, email,phone,spent)
values
  (1,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (2,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (3,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (4,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (5,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (6,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);

select * from customers ;

-- set up roles
CREATE OR REPLACE ROLE ANALYST_MASKED;
CREATE OR REPLACE ROLE ANALYST_FULL;

GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_MASKED;
GRANT USAGE ON DATABASE DEMO_DB TO ROLE ANALYST_FULL;

-- grant select on table to roles
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_MASKED;
GRANT SELECT ON TABLE DEMO_DB.PUBLIC.CUSTOMERS TO ROLE ANALYST_FULL;

GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_MASKED;
GRANT USAGE ON SCHEMA DEMO_DB.PUBLIC TO ROLE ANALYST_FULL;

-- grant warehouse access to roles
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_MASKED;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ANALYST_FULL;


-- assign roles to a user
GRANT ROLE ANALYST_MASKED TO USER VITECHSNOWBATCH27;
GRANT ROLE ANALYST_FULL TO USER VITECHSNOWBATCH27;


select current_user()
-- Set up masking policy

create or replace masking policy phone_policy 
    as (val varchar) returns varchar ->
            case        
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else '##-###-##'
            end;
  

-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN phone 
SET MASKING POLICY phone_policy ;



----------------------

DROP masking policy phone_policy;

create or replace masking policy email_policy as (val varchar) returns varchar ->
            case
            when current_role() in ('ANALYST_FULL', 'ACCOUNTADMIN') then val
            else CONCAT(LEFT(val,2),'*******')
            end;


-- Apply policy on a specific column 
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN email 
SET MASKING POLICY email_policy ;


---UNSET
ALTER TABLE IF EXISTS CUSTOMERS MODIFY COLUMN phone 
UNSET MASKING POLICY  ;








-- Validating policies

USE ROLE ANALYST_FULL;
SELECT * FROM CUSTOMERS;

USE ROLE ANALYST_MASKED;
SELECT * FROM CUSTOMERS;


---------------------------------------------------------

select current_user()  --VITECHSNOWBATCH27  

--reader account 

CREATE MANAGED ACCOUNT vitech_snow_account
ADMIN_NAME = vitech_snow_admin,
ADMIN_PASSWORD = 'Test@123456789',
TYPE = READER;


// Show accounts
SHOW MANAGED ACCOUNTS;


// Create a share object
CREATE OR REPLACE SHARE music_SHARE;

---- Setup Grants ----

// Grant usage on database
GRANT USAGE ON DATABASE manage_db TO SHARE music_SHARE; 

// Grant usage on schema
GRANT USAGE ON SCHEMA manage_db.PUBLIC TO SHARE music_SHARE; 

// Grant SELECT on table

GRANT SELECT ON TABLE manage_db.PUBLIC.music_json TO SHARE music_SHARE; 

GRANT SELECT ON TABLE MANAGE_DB.PUBLIC.NETFLIX_TITLES TO SHARE music_SHARE; 

// Validate Grants
SHOW GRANTS TO SHARE music_SHARE;


---- Add Consumer Account ----
ALTER SHARE music_SHARE ADD ACCOUNT=VWIUZSL.VITECH_SNOW_ACCOUNT;



delete from MANAGE_DB.PUBLIC.MUSIC_JSON



-------------------------consumer sqls-------------------------



show databases;


---Consumer to read --open anothere browser with differet credentials 
-- Create database from share --  to verify the shares 

// Show all shares (consumer & producers)
SHOW SHARES;

// See details on share
---Consumer to read --open anothere browser with differet credentials 
-- Create database from share --  to verify the shares 

// Show all shares (consumer & producers)
SHOW SHARES;

// See details on share
DESC SHARE <account_name_producer>.ORDERS_SHARE;

DESC SHARE VWIUZSL.GB86771.MUSIC_SHARE;

// Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE <account_name_producer>.ORDERS_SHARE;

// Create a database in consumer account using the share
CREATE DATABASE DATA_SHARE_DB FROM SHARE VWIUZSL.GB86771.MUSIC_SHARE;


-----------------------

select * from DATA_SHARE_DB.PUBLIC.MUSIC_JSON;
select * from DATA_SHARE_DB.PUBLIC.NETFLIX_TITLES;

delete from  DATA_SHARE_DB.PUBLIC.NETFLIX_TITLES;







							
Displaying class-19.txt.