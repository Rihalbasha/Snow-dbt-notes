


class-14.txt
Page
1
/
1
100%
                          Snowflake Training 
							     Class-14
							------------------------
							    SnowPipe
								Data unloading 
								https://youtu.be/FJdCuU7H0z8
							
	SnowPipe: Continious data flow from any external systems without manual intervention

1. Create AWS account and create S3 bucket .
2. If s3 bucket is there then upload the files. 
3. Create IAM Roles from AWS to get access for S3. 
4. Create storage integration from Snowflake copy user ARN and extid and paste it in AWS roles.
                                                            (trust realtion ships)
5. Create a stage and list the stage.
6. Create table then use the copy command to load the data.
7. Create snowpipe on top of Copy command 
8. describe pipe and copy notification channle and paste into AWS --> properties -->event notification --> SQS
9. Refresh the pipe and place the files into AWS S3 and verify after 1 min 

10. Validate the table data 	
							

24 hrs -->  1 hr ---> 24 times u need to run copy command 


// First step: Load Raw JSON

CREATE DATABASE  MANAGE_DB ;

CREATE SCHEMA MANAGE_DB.EXTERNAL_STAGES ;

use MANAGE_DB;

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG 
URL = "s3://vitech-batch-27/csv/" ;

LIST @MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG ;



---CREATE STORAGE INTEGRATION 


CREATE OR REPLACE STORAGE INTEGRATION my_s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::088070741183:role/SNOWDBT27ROLES'
  STORAGE_ALLOWED_LOCATIONS = ('s3://vitech-batch-27/csv/', 's3://vitech-batch-27/json/')
  -- Optional: STORAGE_BLOCKED_LOCATIONS = ('s3://my-snowflake-data-bucket/incoming/private/')
;


describe integration my_s3_int;



--------------------

CREATE OR REPLACE STAGE  MANAGE_DB.EXTERNAL_STAGES.json_STG 
  URL = 's3://vitech-batch-27/json/'
  STORAGE_INTEGRATION =  my_s3_int;



  list @MANAGE_DB.EXTERNAL_STAGES.json_STG ;




  CREATE OR REPLACE TABLE MANAGE_DB.public.MUSIC_JSON 
  (RAW_DATA    VARIANT );

--------create snowpipe
CREATE PIPE  MANAGE_DB.public.MUSIC_PIPE
AUTO_INGEST = TRUE 
AS 
 COPY INTO MANAGE_DB.public.MUSIC_JSON 
 FROM @MANAGE_DB.EXTERNAL_STAGES.json_STG 
 FILE_FORMAT = (TYPE=JSON) ;


DESCRIBE PIPE MANAGE_DB.public.MUSIC_PIPE;


ALTER PIPE  MANAGE_DB.public.MUSIC_PIPE refresh;

 SELECT * FROM MANAGE_DB.public.MUSIC_JSON ;

 --30sec - 1min 

 // Resume pipe
ALTER PIPE MANAGE_DB.public.MUSIC_PIPE SET PIPE_EXECUTION_PAUSED = false 

// Verify pipe is running again
SELECT SYSTEM$PIPE_STATUS('MANAGE_DB.public.MUSIC_PIPE') 



-------------------------


select * from HR.VIT.EMPLOYEES;


COPY INTO @MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG/emp1_export_
FROM HR.VIT.EMPLOYEES
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- Wraps text fields with quotes to protect commas
    COMPRESSION = 'GZIP'              -- Compresses files automatically
)
HEADER = TRUE                         -- Includes column names in the first row
OVERWRITE = TRUE                      -- Replaces existing files in that folder


  
Displaying class-13.txt.