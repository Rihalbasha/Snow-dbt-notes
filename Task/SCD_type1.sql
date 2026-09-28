

---SCD=slowly changing dimensions

---- type1= It isoverwrite the data
-----type2= maintain full hisroty of the data nij row level
-----type3=limited hostory


select*from HR.BRONZE.EMPLOYEES;

delete from HR.BRONZE.EMPLOYEES;


-- 1. Create Source Table
CREATE TABLE IF NOT EXISTS HR.BRONZE.EMPLOYEES (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Insert Initial Data into Source
INSERT INTO HR.BRONZE.EMPLOYEES (CID, NAME, EMAIL, ADDRS, STATUS)
VALUES
(111, 'John Smith', 'john.smith@email.com', 'New York, USA', 'ACTIVE'),
(211, 'Mary Johnson', 'mary.johnson@email.com', 'Chicago, USA', 'ACTIVE'),
(311, 'David Brown', 'david.brown@email.com', 'Dallas, USA', 'INACTIVE'),
(411, 'Lisa Wilson', 'lisa.wilson@email.com', 'Seattle, USA', 'ACTIVE'),
(511, 'Michael Davis', 'michael.davis@email.com', 'Boston, USA', 'PENDING');

-- 3. Create Target Table
CREATE TABLE IF NOT EXISTS HR.SILVER.EMPLOYEE_TGT (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Create Stream on Source Table
CREATE OR REPLACE STREAM HR.BRONZE.EMP_STREAM 
  ON TABLE HR.BRONZE.EMPLOYEES;

-- 5. Query both tables
SELECT * FROM HR.BRONZE.EMPLOYEES;
SELECT * FROM HR.SILVER.EMPLOYEE_TGT;

INSERT INTO HR.BRONZE.employees (CID, NAME, EMAIL, ADDRS, STATUS)
VALUES
--(101, 'John Smith', 'john.smith@email.com', 'New York, USA', 'ACTIVE'),
(201, 'Mary Johnson', 'mary.johnson@email.com', 'Chicago, USA', 'ACTIVE'),
(311, 'David Brown', 'david.brown@email.com', 'Dallas, USA', 'INACTIVE'),
(411, 'Lisa Wilson', 'lisa.wilson@email.com', 'Seattle, USA', 'ACTIVE'),
(511, 'Michael Davis', 'michael.davis@email.com', 'Boston, USA', 'PENDING');


CREATE TABLE HR.SILVER.employee_TGT (
    CID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(255),
    ADDRS VARCHAR(500),
    STATUS VARCHAR(20),
    CREATTIMT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-------source ----tgt tables is there 

select*from HR.BRONZE.EMPLOYEES;


select*from HR.SILVER.employee_TGT;

----creating the stream ---

create or replace stream HR.BRONZE.emp_stream on table HR.SILVER.employee_TGT;-------HR.BRONZE.emp_stream this is the stream id+ 


select*from HR.BRONZE.emp_stream; ------willcheck the updates here 




CREATE OR REPLACE TASK HR.BRONZE.TASK_SCD1_SYNC_EMP
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('HR.BRONZE.EMP_STREAM')
AS
MERGE INTO HR.SILVER.EMPLOYEE_TGT AS tgt
USING HR.BRONZE.EMP_STREAM AS stm
ON tgt.CID = stm.CID
WHEN MATCHED AND stm.METADATA$ACTION = 'DELETE' AND stm.METADATA$ISUPDATE = FALSE THEN
  DELETE
WHEN MATCHED AND stm.METADATA$ACTION = 'INSERT' AND stm.METADATA$ISUPDATE = TRUE THEN
  UPDATE SET 
    tgt.NAME = stm.NAME,
    tgt.EMAIL = stm.EMAIL,
    tgt.ADDRS = stm.ADDRS,
    tgt.STATUS = stm.STATUS,
    tgt.CREATTIMT = stm.CREATTIMT
WHEN NOT MATCHED AND stm.METADATA$ACTION = 'INSERT' THEN
  INSERT (CID, NAME, EMAIL, ADDRS, STATUS, CREATTIMT)
  VALUES (stm.CID, stm.NAME, stm.EMAIL, stm.ADDRS, stm.STATUS, stm.CREATTIMT);

-- Resume the task
ALTER TASK HR.BRONZE.TASK_SCD1_SYNC_EMP RESUME;

SELECT SYSTEM$STREAM_HAS_DATA('HR.BRONZE.EMP_STREAM');
