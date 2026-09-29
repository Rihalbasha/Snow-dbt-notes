


CREATE DATABASE  MANAGE_DB ;

CREATE SCHEMA MANAGE_DB.EXTERNAL_STAGES ;

use MANAGE_DB;

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG 
URL = "s3://rihalaws/csv/" ;

LIST @MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG ;



---CREATE STORAGE INTEGRATION 


CREATE OR REPLACE STORAGE INTEGRATION my_s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::548848855300:role/Intigration'
  STORAGE_ALLOWED_LOCATIONS = ('s3://rihalaws/csv/')
  -- Optional: STORAGE_BLOCKED_LOCATIONS = ('s3://my-snowflake-data-bucket/incoming/private/')
;


describe integration my_s3_int;

-- Create an external stage referencing the storage integration
CREATE OR REPLACE STAGE  MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG 
  URL = 's3://rihalaws/csv/'
  STORAGE_INTEGRATION =  my_s3_int;
  ---FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);


  list @MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG; 


CREATE OR REPLACE TABLE MANAGE_DB.public.netflix_titles (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year STRING,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING 
);



-- Load the data into a Snowflake table
COPY INTO MANAGE_DB.public.netflix_titles
  FROM @MANAGE_DB.EXTERNAL_STAGES.NETFLIX_STG 
  file_format =MANAGE_DB.file_formats.netflix_csv_format ;
 -- on_error = continue 

create schema MANAGE_DB.file_formats;



    CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.netflix_csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- This stops commas inside descriptions from breaking columns
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE; -- Bypasses the error if the file still has extra structural columns



select * from MANAGE_DB.public.netflix_titles;



--------------------

CREATE OR REPLACE STAGE  MANAGE_DB.EXTERNAL_STAGES.json_STG 
  URL = 's3://vitech-batch-27/json/'
  STORAGE_INTEGRATION =  my_s3_int;



  list @MANAGE_DB.EXTERNAL_STAGES.json_STG ;




  CREATE OR REPLACE TABLE MANAGE_DB.public.MUSIC_JSON 
  (RAW_DATA    VARIANT );

 COPY INTO MANAGE_DB.public.MUSIC_JSON 
 FROM @MANAGE_DB.EXTERNAL_STAGES.json_STG 
 FILE_FORMAT = (TYPE=JSON) ;



 SELECT * FROM MANAGE_DB.public.MUSIC_JSON ;

