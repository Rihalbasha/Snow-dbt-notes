


----ELT extract,loading,tranformation----

-----ETL(extract loading TRANSACTIONS)----
CREATE DATABASE VITECH_DEV_DB;
CREATE OR REPLACE TABLE VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT (
    Loan_ID STRING,
    loan_status STRING,
    Principal STRING,
    terms STRING,
    effective_date STRING,
    due_date STRING,
    paid_off_time STRING,
    past_due_days STRING,
    age STRING,
    education STRING,
    Gender STRING
);
SELECT*FROM
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT;
---url= 's3://bucketsnowflakes3/Loan_payments_data.csv'
    copy into VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
from
    's3://bucketsnowflakes3/Loan_payments_data.csv';
    ---skipping the header
    copy into VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
from
    's3://bucketsnowflakes3/Loan_payments_data.csv' file_format = (type = csv, skip_header = 1);
    --transformation--
select
    loan_id,
    terms,(terms * 5) / 10 as intr
from
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
where
    loan_id = 'loan-id'
SELECT
    *
FROM
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT;
----fnding males and females
    ----for ecternal stage
    create
    or replace stage VITECH_DEV_DB.STAGES.AWS_EXT_STAGE url = 's3://bucketsnowflakes3/' list @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE;
--------liste of the data-----
SELECT
    *
FROM
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT;
COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
FROM
    @VITECH_DEV_DB.STAGES.INT_STAGE FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1);
---CRETAE EXT STAGE
    CREATE
    OR REPLACE STAGE VITECH_DEV_DB.STAGES.AWS_EXT_STAGE url = 's3://bucketsnowflakes3/';
--LIST THE FILES
    LIST @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE;
COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1
FROM
    @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1) FILEs = (
        'Loan_payments_data.csv',
        'Loan_payments_data1.csv'
    );
COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1
FROM
    @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1) PATTERN = '.*Loan_payments.*\.csv';
select
    *
from
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1;
CREATE
    OR REPLACE TABLE VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1 (
        Loan_ID STRING,
        loan_status STRING,
        Principal STRING,
        terms STRING,
        effective_date STRING,
        due_date STRING,
        paid_off_time STRING,
        past_due_days STRING,
        age STRING,
        education STRING,
        Gender STRING
    );
select
    $1,
    $2,
    $3,
    $4
from
    @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE;
CREATE
    OR REPLACE TABLE VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5 (
        Loan_ID STRING,
        loan_status STRING,
        Principal STRING,
        terms STRING,
        effective_date STRING
    );
COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5
FROM
    (
        select
            $1,
            $2,
            $3,
            $4,
            $5
        from
            @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE
    ) FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1) PATTERN = '.*Loan_payments.*\.csv';
select
    *
from
    VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5;
------task ----
    // Creating ORDERS table
    ---CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);