


class-12.txt
Page
1
/
1
100%
                           Snowflake Training 
							     Class-12
							------------------
							Dataloading 
							Semi structured Data 
							
							
			Json , XML , parquet 
			
			
			
			--Create table with   VARIANT data type 
			
			
			
eid name email addrs 

int string string varchar(20) 



{
  "city": "Bakersfield",
  "first_name": "Portia",
  "gender": "Male",
  "id": 1,
  "job": {
    "salary": 32000,
    "title": "Financial Analyst"
  },
  "last_name": "Gioani",
  "prev_company": [],
  "spoken_languages": [
    {
      "language": "Kazakh",
      "level": "Advanced"
    },
    {
      "language": "Lao",
      "level": "Basic"
    }
  ]
}


TASK : 


    // Create file format and stage object
    
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT
    TYPE = 'parquet';

CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'   
    FILE_FORMAT = MANAGE_DB.FILE_FORMATS.PARQUET_FORMAT;
	
	
	
AWS free trail account 
https://youtu.be/CCaVgwVGlt8?si=IN6AEp7fdbAON4iS



SQLs:
-------

// First step: Load Raw JSON

CREATE DATABASE  MANAGE_DB ;

CREATE SCHEMA MANAGE_DB.EXTERNAL_STAGES ;

CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

LIST @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE;

----CREATE TABLE WITH VARIANT DATA TYPE 
CREATE TABLE MANAGE_DB.PUBLIC.HR_JSON 
      (RAW_DATA    VARIANT) ;

COPY INTO MANAGE_DB.PUBLIC.HR_JSON
FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
FILE_FORMAT = (TYPE=JSON);


   
SELECT * FROM MANAGE_DB.PUBLIC.HR_JSON;



SELECT $1:city :: string as city ,
       $1:first_name:: string as first_name ,
       $1:gender :: string as gender,
       $1:id :: int as id 
       FROM MANAGE_DB.PUBLIC.HR_JSON;



create table hr_csv as 
(
SELECT $1:city :: string as city ,
       $1:first_name:: string as first_name ,
       $1:gender :: string as gender,
       $1:id :: int as id 
       FROM MANAGE_DB.PUBLIC.HR_JSON
);


select * from hr_csv;


SELECT $1:city :: string as city ,
       $1:first_name:: string as first_name ,
       $1:gender :: string as gender,
       $1:id :: int as id, 
       $1:job.salary ,
       $1:job.title
       FROM MANAGE_DB.PUBLIC.HR_JSON ;



SELECT raw_data:city :: string as city ,
       raw_data:first_name:: string as first_name ,
       raw_data:gender :: string as gender,
       raw_data:id :: int as id, 
       raw_data:job.salary ,
       raw_data:job.title,
       raw_data:spoken_languages[0].language ,
       raw_data:spoken_languages[0].level ,
              raw_data:spoken_languages[1].language ,
       raw_data:spoken_languages[1].level 
       FROM MANAGE_DB.PUBLIC.HR_JSON

       union 

SELECT raw_data:city :: string as city ,
       raw_data:first_name:: string as first_name ,
       raw_data:gender :: string as gender,
       raw_data:id :: int as id, 
       raw_data:job.salary ,
       raw_data:job.title,
       raw_data:spoken_languages[1].language ,
       raw_data:spoken_languages[1].level 
       FROM MANAGE_DB.PUBLIC.HR_JSON ;



select
      raw_data:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from MANAGE_DB.PUBLIC.HR_JSON, table(flatten(raw_data:spoken_languages)) f;



//another method using lateral flatten 

SELECT
  raw_data:id:: int as id ,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM MANAGE_DB.PUBLIC.HR_JSON,
LATERAL FLATTEN(input => raw_data:spoken_languages) hr;




---final table data 

create table hr_final 
as 
(
SELECT
  raw_data:id:: int as id ,
  raw_data:city :: string as city ,
       raw_data:first_name:: string as first_name ,
       raw_data:gender :: string as gender,
      -- raw_data:id :: int as id, 
       raw_data:job.salary :: decimal as salary ,
       raw_data:job.title :: string as titile,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM MANAGE_DB.PUBLIC.HR_JSON,
LATERAL FLATTEN(input => raw_data:spoken_languages) hr
) ;


select * from hr_final;










Displaying class-12.txt.