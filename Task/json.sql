
--how to upload JSon


--Json formate data comverting into a SQL TABLE
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



---need to creat table with VARINT date type

create database Manager_DB;

create schema manager_DB.external_stages;

create or replace stage manager_DB.external_stages.jsonstage

URL='s3://bucketsnowflake-jsondemo';
list @manager_DB.external_stages.jsonstage;

---after this we need to create a table.---

create table Manager_DB.public.HR_json
    (raw_DATA variant);


copy into Manager_DB.public.HR_json
from @manager_DB.external_stages.jsonstage
FILE_FORMAT =(TYPE=JSON);


select*from Manager_DB.public.HR_json;

----converting the data into table

select $1:city::string as city,
       $1:first_name:: string as first_name,
       $1:gender::string as gender,
       $1:id:: int as id
       from Manager_DB.public.HR_json;



Create or replace table HR_CSV  AS ------This the table we need to create 
(
select $1:city::string as city,
       $1:first_name:: string as first_name,
       $1:gender::string as gender,
       $1:id:: int as id
       from Manager_DB.public.HR_json
       );
       -----we cannot create this every time soo that in top thisquery will create one table.

       select*from HR_CSV;



--------"job": {
    "salary": 32000,
    "title": "Financial Analyst"---for this how to write 

    -------$1:job.salary:: int as salary,
   ----    $1:job.title:: string as title---this we need to add 

    

select $1:city::string as city,
       $1:first_name:: string as first_name,
       $1:gender::string as gender,
       $1:id:: int as id,
       $1:job.salary:: int as salary,
       $1:job.title:: string as title
       from Manager_DB.public.HR_json

------instedof $1 we can also use another method like Raw_data

select Raw_data:city::string as city,
       Raw_data:first_name:: string as first_name,
       Raw_data:gender::string as gender,
       Raw_data:id:: int as id,
       Raw_data:job.salary:: int as salary,
       Raw_data:job.title:: string as title
       from Manager_DB.public.HR_json

  -------spoken_languages": [
    {
      "language": "Kazakh",
      "level": "Advanced"
    },
    {
      "language": "Lao",
      "level": "Basic"------for this we have a more languages,
      


select Raw_data:city::string as city,
       Raw_data:first_name:: string as first_name,
       Raw_data:gender::string as gender,
       Raw_data:id:: int as id,
       Raw_data:job.salary:: int as salary,
       Raw_data:job.title:: string as title,
       Raw_data:spoken_languages[0].language,
       Raw_data:spoken_languages[0].level,
       Raw_data:spoken_languages[1].language,
       Raw_data:spoken_languages[1].level
       
from Manager_DB.public.HR_json

---another methods
select
      raw_data:first_name::STRING as First_name,
    f.value:language::STRING as First_language,
   f.value:level::STRING as Level_spoken
from Manager_DB.public.HR_json, table(flatten(raw_data:spoken_languages)) f;



//another method using lateral flatten 

SELECT
  raw_data:id:: int as id ,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM Manager_DB.public.HR_json,
LATERAL FLATTEN(input => raw_data:spoken_languages) hr;


---final tale date 


create table hr_final as

(
SELECT
  raw_data:id:: int as id ,
  Raw_data:city::string as city,
       Raw_data:first_name:: string as first_name,
       Raw_data:gender::string as gender,
       
       Raw_data:job.salary:: int as salary,
       Raw_data:job.title:: string as title,
  hr.value:language::STRING AS language,
  hr.value:level::STRING AS level
FROM Manager_DB.public.HR_json,
LATERAL FLATTEN(input => raw_data:spoken_languages) hr
);

select*from hr_final;






    



      
       









    

