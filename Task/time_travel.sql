


CREATE TABLE <table_name> ... CLONE	<source_table_name>




use HR.VIT;

select * from HR.VIT.EMPLOYEES;

show tables ;

ALTER TABLE EMPLOYEES SET DATA_RETENTION_TIME_IN_DAYS=30;




delete  from HR.VIT.EMPLOYEES;


select * from HR.VIT.EMPLOYEES;


SELECT * FROM HR.VIT.EMPLOYEES at (OFFSET => -60*2)


create table emps as 
(
SELECT * FROM HR.VIT.EMPLOYEES at (OFFSET => -60*3)
)


insert into HR.VIT.EMPLOYEES
(
   select * from emps 
)

select * from HR.VIT.EMPLOYEES;

update HR.VIT.EMPLOYEES 
    set first_name = 'Abhinash'

SELECT * FROM HR.VIT.EMPLOYEES before (statement => '01c73b48-3203-6aa9-0018-18160011b26a')


select * from HR.VIT.EMPLOYEES;


update HR.VIT.EMPLOYEES 
    set email = 'abc@gmail.com';

    select current_timestamp()

SELECT * FROM HR.VIT.EMPLOYEES before (timestamp => '2026-09-21 19:20:25.972 -0700'::timestamp)



--30  31st  --filesafe --(1-7)   


-----------------zero copy clone -----------------

CREATE TABLE <table_name> ... CLONE	<source_table_name>


CREATE database hr_clone2  CLONE	hr ;


CREATE schema hr_clone2.vit_copy  CLONE	hr_clone2.vit ;


CREATE schema hr_clone2.ext_stgs_copy  CLONE	manage_db.external_stages ;



create table hr.vit.netfilx_copy   clone MANAGE_DB.PUBLIC.NETFLIX_TITLES;


select * from  MANAGE_DB.PUBLIC.NETFLIX_TITLES ;  --31148



select * from  hr.vit.netfilx_copy ;

delete from  hr.vit.netfilx_copy where release_year >= 2010;


drop database HR_CLONE2;

drop database HR_CLONE1;


undrop database HR_CLONE1;


create database VITECH_prod_DB  clone VITECH_DEV_DB ;


delete from VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT ;

select * from  VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT ;



select * from  VITECH_prod_DB.PUBLIC.LOAN_PAYMENT ;


create or replace table   VITECH_DEV_DB.PUBLIC.LOAN_PAYMENT clone VITECH_prod_DB.PUBLIC.LOAN_PAYMENT ;

