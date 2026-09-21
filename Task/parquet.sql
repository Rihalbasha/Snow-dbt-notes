

---how to convert the parquet file into snowflake---



------parqute url 's3://snowflakeparquetdemo'


create database Leader_DB;

create schema Leader_DB.external_stages;

create or replace stage Leader_DB.external_stages.parquetstage

URL='s3://snowflakeparquetdemo';
list @Leader_DB.external_stages.parquetstage;

---after this we need to create a table.---

create table Leader_DB.public.TL_parquet
    (raw_DATA variant);


copy into Leader_DB.public.TL_parquet
from @Leader_DB.external_stages.parquetstage
FILE_FORMAT =(TYPE=parquet);

select*from Leader_DB.public.TL_parquet;

--final reselts 

CREATE OR REPLACE TABLE Leader_DB.public.TL_FINAL AS 
SELECT 
    raw_data:id::STRING             AS evaluation_id,
    raw_data:cat_id::STRING         AS category_id,
    raw_data:dept_id::STRING        AS department_id,
    raw_data:item_id::STRING        AS item_id,
    raw_data:state_id::STRING       AS state_id,
    raw_data:store_id::STRING       AS store_id,
    raw_data:value::INT             AS value_amount,
    raw_data:d::INT                 AS day_code,
    raw_data:date::TIMESTAMP       AS record_date
FROM Leader_DB.public.TL_parquet;

SELECT * FROM Leader_DB.public.TL_FINAL;