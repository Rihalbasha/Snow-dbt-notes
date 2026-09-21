

----ETL file loading   Extract,tranform,loading----


-------------------TASK --------


// Creating ORDERS table

--CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));


-- 1. Create Database and Schema
CREATE DATABASE IF NOT EXISTS OUR_FIRST_DB;

-- 2. Create Target Table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

-- 3. Create External Stage pointing to S3
CREATE OR REPLACE STAGE OUR_FIRST_DB.PUBLIC.AWS_EXT_STAGE 
URL = 's3://bucketsnowflakes3/OrderDetails.csv';

-- 4. List Files in Stage
LIST @OUR_FIRST_DB.PUBLIC.AWS_EXT_STAGE;

-- 5. Query Stage Directly to Preview Columns
SELECT $1, $2, $3, $4, $5, $6 
FROM @OUR_FIRST_DB.PUBLIC.AWS_EXT_STAGE 
(FILE_FORMAT => 'CSV', SKIP_HEADER => 1);

-- 6. Load Data: Direct S3 URL Load
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
FROM 's3://bucketsnowflakes3/Order_data.csv' 
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1);

-- 7. Load Data: Stage Load using Pattern Matching
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
FROM @OUR_FIRST_DB.PUBLIC.AWS_EXT_STAGE 
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1) 
PATTERN = '.*orders.*\.csv';

-- 8. Verify Loaded Results
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS ;