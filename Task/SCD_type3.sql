

select*from HR.PUBLIC.COUNTRIES;


USE DATABASE HR;

--------------------------------------------------------------------------------
-- 1. CREATE SOURCE TABLE IN BRONZE LAYER
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE HR.BRONZE.COUNTRIES (
    COUNTRY_ID VARCHAR(5) PRIMARY KEY,
    COUNTRY_NAME VARCHAR(100),
    REGION_ID INT,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------------------------
-- 2. CREATE TARGET TABLE IN SILVER LAYER (WITH SCD TYPE 3 METADATA)
--------------------------------------------------------------------------------
CREATE OR REPLACE TABLE HR.SILVER.COUNTRIES_TGT (
    COUNTRY_ID VARCHAR(5) PRIMARY KEY,
    COUNTRY_NAME VARCHAR(100),
    PREV_COUNTRY_NAME VARCHAR(100) DEFAULT NULL, -- Preserves previous historical value
    REGION_ID INT,
    PREV_REGION_ID INT DEFAULT NULL,              -- Preserves previous region ID
    LAST_UPDATED TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------------------------
-- 3. CREATE STREAM ON TOP OF SOURCE TABLE
--------------------------------------------------------------------------------
CREATE OR REPLACE STREAM HR.BRONZE.COUNTRY_STREAM 
  ON TABLE HR.BRONZE.COUNTRIES;

--------------------------------------------------------------------------------
-- 4. INSERT INITIAL RECORDS INTO SOURCE & VERIFY STREAM
--------------------------------------------------------------------------------
INSERT INTO HR.BRONZE.COUNTRIES (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
VALUES 
('US', 'United States', 1),
('IN', 'India', 2);

-- Query the stream to verify captured changes
SELECT * FROM HR.BRONZE.COUNTRY_STREAM;

--------------------------------------------------------------------------------
-- 5. WRITE MERGE SQL (SCD TYPE 3) & CREATE AUTOMATED TASK
--------------------------------------------------------------------------------
CREATE OR REPLACE TASK HR.BRONZE.TASK_SCD3_COUNTRY_SYNC
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '1 MINUTE'
  WHEN SYSTEM$STREAM_HAS_DATA('HR.BRONZE.COUNTRY_STREAM')
AS
MERGE INTO HR.SILVER.COUNTRIES_TGT AS tgt
USING HR.BRONZE.COUNTRY_STREAM AS stm
ON tgt.COUNTRY_ID = stm.COUNTRY_ID

-- Handle Deletes in Bronze
WHEN MATCHED AND stm.METADATA$ACTION = 'DELETE' AND stm.METADATA$ISUPDATE = FALSE THEN
  DELETE

-- Handle Updates (SCD Type 3: Shift current value to PREV column, overwrite current value)
WHEN MATCHED AND stm.METADATA$ACTION = 'INSERT' AND stm.METADATA$ISUPDATE = TRUE THEN
  UPDATE SET 
    tgt.PREV_COUNTRY_NAME = NVL2(NULLIF(tgt.COUNTRY_NAME, stm.COUNTRY_NAME), tgt.COUNTRY_NAME, tgt.PREV_COUNTRY_NAME),
    tgt.COUNTRY_NAME = stm.COUNTRY_NAME,
    tgt.PREV_REGION_ID = NVL2(NULLIF(tgt.REGION_ID, stm.REGION_ID), tgt.REGION_ID, tgt.PREV_REGION_ID),
    tgt.REGION_ID = stm.REGION_ID,
    tgt.LAST_UPDATED = CURRENT_TIMESTAMP()

-- Handle Inserts (Brand new countries)
WHEN NOT MATCHED AND stm.METADATA$ACTION = 'INSERT' THEN
  INSERT (COUNTRY_ID, COUNTRY_NAME, PREV_COUNTRY_NAME, REGION_ID, PREV_REGION_ID, LAST_UPDATED)
  VALUES (stm.COUNTRY_ID, stm.COUNTRY_NAME, NULL, stm.REGION_ID, NULL, CURRENT_TIMESTAMP());

--------------------------------------------------------------------------------
-- 6. RESUME TASK AND INSERT/UPDATE SOURCE RECORDS
--------------------------------------------------------------------------------
-- Resume the task to start automatic execution
ALTER TASK HR.BRONZE.TASK_SCD3_COUNTRY_SYNC RESUME;

-- Update existing country name (SCD Type 3 trigger: historical value moved to PREV_COUNTRY_NAME)
UPDATE HR.BRONZE.COUNTRIES 
SET COUNTRY_NAME = 'United States of America' 
WHERE COUNTRY_ID = 'US';

-- Insert brand new country
INSERT INTO HR.BRONZE.COUNTRIES (COUNTRY_ID, COUNTRY_NAME, REGION_ID)
VALUES ('CA', 'Canada', 1);

--------------------------------------------------------------------------------
-- 7. VERIFY FINAL TARGET TABLE DATA
--------------------------------------------------------------------------------
-- Wait 1 minute for task execution, then verify target data:
SELECT * FROM HR.SILVER.COUNTRIES_TGT ORDER BY COUNTRY_ID;
