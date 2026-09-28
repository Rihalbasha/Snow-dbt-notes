

select*from HR.PUBLIC.DEPARTMENTS;
-- Set active Database and Schema context
USE DATABASE HR;
USE SCHEMA PUBLIC;

-- Query the table
SELECT * FROM DEPARTMENTS;

--------------------------------------------------------------

-- Set active context
USE DATABASE HR;

--------------------------------------------------------------------------------
-- 1. CREATE SOURCE TABLE IN BRONZE LAYER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE HR.BRONZE.DEPARTMENTS (
    DEPT_ID INT,
    DEPT_NAME VARCHAR(100),
    LOCATION VARCHAR(100),
    MANAGER_ID INT,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------------------------
-- 2. CREATE TARGET TABLE IN SILVER LAYER (WITH SCD TYPE 2 METADATA)
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE HR.SILVER.DEPARTMENTS_TGT (
    DEPT_ID INT,
    DEPT_NAME VARCHAR(100),
    LOCATION VARCHAR(100),
    MANAGER_ID INT,
    START_DATE TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    END_DATE TIMESTAMP_NTZ DEFAULT NULL,
    IS_CURRENT BOOLEAN DEFAULT TRUE
);

--------------------------------------------------------------------------------
-- 3. CREATE STREAM ON TOP OF SOURCE TABLE
--------------------------------------------------------------------------------
CREATE OR REPLACE STREAM HR.BRONZE.DEPT_STREAM 
  ON TABLE HR.BRONZE.DEPARTMENTS;

--------------------------------------------------------------------------------
-- 4. INSERT INITIAL RECORDS INTO SOURCE & VERIFY STREAM
--------------------------------------------------------------------------------
INSERT INTO HR.BRONZE.DEPARTMENTS (DEPT_ID, DEPT_NAME, LOCATION, MANAGER_ID)
VALUES 
(10, 'Human Resources', 'New York', 101),
(20, 'Engineering', 'San Francisco', 102);

-- Query the stream to verify captured changes
SELECT * FROM HR.BRONZE.DEPT_STREAM;

--------------------------------------------------------------------------------
-- 5. WRITE MERGE SQL & CREATE AUTOMATED TASK
--------------------------------------------------------------------------------
CREATE OR REPLACE TASK HR.BRONZE.TASK_SCD2_DEPT_SYNC
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('HR.BRONZE.DEPT_STREAM')
AS
MERGE INTO HR.SILVER.DEPARTMENTS_TGT AS tgt
USING (
  -- Pass-through of all stream records
  SELECT 
    DEPT_ID, DEPT_NAME, LOCATION, MANAGER_ID,
    METADATA$ACTION, METADATA$ISUPDATE,
    DEPT_ID AS JOIN_KEY
  FROM HR.BRONZE.DEPT_STREAM

  UNION ALL

  -- Duplicate updated rows with NULL join keys to force INSERT of new active versions
  SELECT 
    DEPT_ID, DEPT_NAME, LOCATION, MANAGER_ID,
    METADATA$ACTION, METADATA$ISUPDATE,
    NULL AS JOIN_KEY
  FROM HR.BRONZE.DEPT_STREAM
  WHERE METADATA$ACTION = 'INSERT' AND METADATA$ISUPDATE = TRUE
) AS stm
ON tgt.DEPT_ID = stm.JOIN_KEY AND tgt.IS_CURRENT = TRUE

-- Expire existing active record on DELETE
WHEN MATCHED AND stm.METADATA$ACTION = 'DELETE' AND stm.METADATA$ISUPDATE = FALSE THEN
  UPDATE SET 
    tgt.END_DATE = CURRENT_TIMESTAMP(),
    tgt.IS_CURRENT = FALSE

-- Expire existing active record on UPDATE
WHEN MATCHED AND stm.METADATA$ACTION = 'INSERT' AND stm.METADATA$ISUPDATE = TRUE THEN
  UPDATE SET 
    tgt.END_DATE = CURRENT_TIMESTAMP(),
    tgt.IS_CURRENT = FALSE

-- Insert new records (both brand new rows & new active versions from updates)
WHEN NOT MATCHED AND stm.METADATA$ACTION = 'INSERT' THEN
  INSERT (DEPT_ID, DEPT_NAME, LOCATION, MANAGER_ID, START_DATE, END_DATE, IS_CURRENT)
  VALUES (stm.DEPT_ID, stm.DEPT_NAME, stm.LOCATION, stm.MANAGER_ID, CURRENT_TIMESTAMP(), NULL, TRUE);

--------------------------------------------------------------------------------
-- 6. RESUME TASK AND INSERT/UPDATE SOURCE RECORDS
--------------------------------------------------------------------------------
-- Resume the task to start listening
ALTER TASK HR.BRONZE.TASK_SCD2_DEPT_SYNC RESUME;

-- Update existing department location (SCD2 trigger)
UPDATE HR.BRONZE.DEPARTMENTS 
SET LOCATION = 'Austin' 
WHERE DEPT_ID = 20;

-- Insert brand new department
INSERT INTO HR.BRONZE.DEPARTMENTS (DEPT_ID, DEPT_NAME, LOCATION, MANAGER_ID)
VALUES (30, 'Finance', 'Chicago', 103);

--------------------------------------------------------------------------------
-- 7. VERIFY FINAL TARGET TABLE DATA
--------------------------------------------------------------------------------
-- Wait 1 minute for task execution, then verify target history:
SELECT * FROM HR.SILVER.DEPARTMENTS_TGT ORDER BY DEPT_ID, START_DATE;