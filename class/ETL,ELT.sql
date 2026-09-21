



class-10.txt
Page
1
/
1
100%
                           Snowflake Training 
							     Class-10
							------------------
							 Data Loading 
							 Batch Loading 
							   --> Stages 
							   --> file formats 
							   --> Copy 
							   
							 ETL Vs ELT  
							 
							 
						
 
 url= 's3://bucketsnowflakes3/Loan_payments_data.csv'

CREATE TABLE OUR_FIRST_DB.PUBLIC.LOAN_PAYMENT (
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
  Gender STRING);							


Stages : 

Internal --> if the file are avialble from you local system then we will create internal stage 

External --> if the files are availble from external systems 
              (S3 , Azure , GCP ..etc) 


SQLS:
------------




CREATE  DATABASE  VITECH_DEV_DB ;



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
  Gender STRING);							


SELECT * FROM VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT; ---url= 's3://bucketsnowflakes3/Loan_payments_data.csv'


COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM 's3://bucketsnowflakes3/Loan_payments_data.csv'
 ;


COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM 's3://bucketsnowflakes3/Loan_payments_data.csv'
 FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) ;

--transformation
 SELECT LOAN_ID ,TERMS , (TERMS * 5)/10  AS INTR  FROM VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT; 

 --find male and female count ??
 


 DELETE FROM  VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT 
 WHERE LOAN_ID = 'Loan_ID' 

 -----------------------

 COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM 's3://bucketsnowflakes3/Loan_payments_data-1.csv'
 FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) ;
 
 COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM 's3://bucketsnowflakes3/Loan_payments_data-2.csv'
 FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) ;
 
 COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM 's3://bucketsnowflakes3/Loan_payments_data-3.csv'
 FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) ;


 ---------------------------------------------------


 CREATE SCHEMA VITECH_DEV_DB.STAGES ;

---CRETAE INT SATGE 
CREATE OR REPLACE STAGE VITECH_DEV_DB.STAGES.INT_STAGE ;

----LIST OF FILES
LIST @VITECH_DEV_DB.STAGES.INT_STAGE;



 SELECT * FROM VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT;

 COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM @VITECH_DEV_DB.STAGES.INT_STAGE
  FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) ;



---CRETAE EXT STAGE 
CREATE OR REPLACE STAGE VITECH_DEV_DB.STAGES.AWS_EXT_STAGE 
 url= 's3://bucketsnowflakes3/' ;


--LIST THE FILES

LIST @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE ;



COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1
 FROM @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE
  FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) 
  FILEs = ('Loan_payments_data.csv','Loan_payments_data1.csv') ;


COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1
FROM @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1)
PATTERN = '.*Loan_payments.*\.csv';


 


select * from VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1;


CREATE OR REPLACE TABLE VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V1 (
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
  Gender STRING);							





select $1, $2,$3 ,$4 from @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE ;



CREATE OR REPLACE TABLE VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5 (
  Loan_ID STRING,
  loan_status STRING,
  Principal STRING,
  terms STRING ,
  effective_date STRING) ;



COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5
FROM (select $1, $2,$3 ,$4,$5 from @VITECH_DEV_DB.STAGES.AWS_EXT_STAGE)
FILE_FORMAT = (TYPE = CSV, SKIP_HEADER = 1)
PATTERN = '.*Loan_payments.*\.csv';



select * from VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT_V5 ;



-------------------TASK --------


// Creating ORDERS table

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));			  
Displaying class-10.txt.