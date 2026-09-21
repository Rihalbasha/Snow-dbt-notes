



class-11.txt
Page
1
/
1
100%
                           Snowflake Training 
							     Class-11
							------------------
							 Copy options 
							 
							 
							 
							 
							 
1  -- 50000 -- PROCESSED 
2   -- 20000 -- PROCESS
3  -- 30000
4  -- 3000
5  -- 4000

INPUT -- 100000 < F1

COPY --

							

// Create new stage
 CREATE OR REPLACE STAGE vitech_dev_db.stages.aws_stage_errorex
    url='s3://bucketsnowflakes4' ;


list @vitech_dev_db.stages.aws_stage_errorex;


 
 // Create example table
 CREATE OR REPLACE TABLE vitech_dev_db.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));



  COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX
  FROM @vitech_dev_db.stages.aws_stage_errorex
  FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
  VALIDATION_MODE = RETURN_ERRORS 


  100-- 1 BAD RECORD 


 COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX
  FROM @vitech_dev_db.stages.aws_stage_errorex
  FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
  ON_ERROR = CONTINUE 

 --- 285 +1498   2 RECORDS ARE SKIPPED

 SELECT * FROM  vitech_dev_db.PUBLIC.ORDERS_EX;  --1783  


 
 COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX
  FROM @vitech_dev_db.stages.aws_stage_errorex
  FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
  ON_ERROR = SKIP_FILE 

   SELECT * FROM  vitech_dev_db.PUBLIC.ORDERS_EX; --285


   
 COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX
  FROM @vitech_dev_db.stages.aws_stage_errorex
  FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
  ON_ERROR = CONTINUE 
  FORCE= TRUE 

  SELECT * FROM  vitech_dev_db.PUBLIC.ORDERS_EX;  


   CREATE OR REPLACE TABLE vitech_dev_db.PUBLIC.ORDERS_EX1 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(3),
    SUBCATEGORY VARCHAR(30));

     COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX1
    FROM @vitech_dev_db.stages.aws_stage_errorex
    FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
    ON_ERROR = CONTINUE 
    TRUNCATECOLUMNS = TRUE 

      SELECT * FROM  vitech_dev_db.PUBLIC.ORDERS_EX1;  


      ---CRETAE INT SATGE 
CREATE OR REPLACE STAGE VITECH_DEV_DB.STAGES.INT_STAGE ;

----LIST OF FILES
LIST @VITECH_DEV_DB.STAGES.INT_STAGE;



 SELECT * FROM VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT;

 COPY INTO VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT
 FROM @VITECH_DEV_DB.STAGES.INT_STAGE
  FILE_FORMAT = (TYPE = CSV , SKIP_HEADER= 1) 
  FORCE= TRUE 
  PURGE=TRUE 


  
list @vitech_dev_db.stages.aws_stage_errorex;
--54622  -- 2000   INPUT < ACTUAL_SIZE   2000 < 54622 
--10512  --        55000 < 54622 --FAIL  

               --    54622+10512 = 64K    55000 < 64K

--100 FILES LIMITED 

 COPY INTO   vitech_dev_db.PUBLIC.ORDERS_EX
  FROM @vitech_dev_db.stages.aws_stage_errorex
  FILE_FORMAT = (TYPE=CSV , SKIP_HEADER=1) 
  ON_ERROR = CONTINUE  
  SIZE_LIMIT = 2000 ;


  SELECT * FROM vitech_dev_db.PUBLIC.ORDERS_EX;
  
  
  
  task --
  
  s3://snowflake-assignments-mc/copyoptions/example1
  
  
  --task---
   CREATE STAGE VITECH_DEV_DB.STAGES.EMPL_STAGE
   URL='s3://snowflake-assignments-mc/copyoptions/example1'


   LIST @VITECH_DEV_DB.STAGES.EMPL_STAGE;

   --HINT :  INFER_SCHEMA ()

   --COUNT OF EMP TABLE RECORDS --
  
  
							
Displaying class-13.txt.