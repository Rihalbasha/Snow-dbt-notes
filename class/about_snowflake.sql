


class-1.txt
Page
1
/
1
100%
	                        Snowflake Training 
							     Class-1
							---------------------
							
							Snowflake 
		1. It is cloud based data ware house platform 
		2. It built on top of AWS /Azure /GCP 
		3. Data storage /data processing and data analytical solutions 
		4. It supports structured / semi structured and un strucutred data 
		5. It is a SAAS (software as a service model) 
		
		
		app.snowflake.com /?tiral=student 
		
		
		
		Data base /SQL 
		
		
	Database :   is nothing a collection of data 
	                  (structured / semi structured and un strucutred data)
					  
	
	Database --> schema --> Tables 
	
	 Schema --> logical representation of the database 
	 Table --> combination of rows/columns 
	 
	 EX: 
	  my-sql 
	  ms sql 
	  oracle 
	  sybase 
	  db2 
	  mango db 
	  snowflake -- dw 
	  
	  
	 Data ware house --> historical data we are storing /large valumes 
	 CRUD -
	 C - create 
	 R - read 
	 U - update 
	 D- delete 
	 
	 SQL --- structured query language 
	    in order to communcate with datbase we are going to sql 
		it is similar to english language 
		
	CRUD -
	 C - create 
	 R - read 
	 U - update 
	 D- delete 
		
		
		
	CREATE 
	INSERT 
	SELECT 
	
	
	DELETE   -- in order to delete entire table data we can use 
	            and if u want to specific record we can use 
				WHERE clause 
	TRUNCATE -- in order to delete entire table data 
	
	DROP     -- it will delete table data and structure of the table 
	
	undrop -- in order to recover database objects (tables/schemas ..etc) 
	
	select top 5 * from SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;


-- Step 1: Create Database
CREATE DATABASE bank;



-- Step 2: Create Schemas
CREATE SCHEMA bank.hdfc;
CREATE SCHEMA bank.axis;
CREATE SCHEMA bank.icici;

-- Step 3: Create Customer table in each schema
CREATE OR REPLACE TABLE bank.hdfc.customer (
    cid INT,
    name STRING,
    email STRING,
    addrs STRING
);


CREATE OR REPLACE TABLE bank.icici.customer (
    cid INT PRIMARY KEY,
    name STRING,
    email STRING,
    addrs STRING
);

-- Insert 10 rows into bank.hdfc.customer
INSERT INTO bank.hdfc.customer (cid, name, email, addrs) VALUES
(1, 'Anil', 'ravi.kumar@hdfc.com', 'Bangalore'),
(2, 'Priya Sharma', 'priya.sharma@hdfc.com', 'Mumbai'),
(3, 'Arjun Mehta', 'arjun.mehta@hdfc.com', 'Delhi'),
(4, 'Sneha Iyer', 'sneha.iyer@hdfc.com', 'Chennai'),
(5, 'Vikram Singh', 'vikram.singh@hdfc.com', 'Hyderabad'),
(6, 'Anita Rao', 'anita.rao@hdfc.com', 'Pune'),
(7, 'Karan Patel', 'karan.patel@hdfc.com', 'Ahmedabad'),
(8, 'Meera Joshi', 'meera.joshi@hdfc.com', 'Kolkata'),
(9, 'Rahul Nair', 'rahul.nair@hdfc.com', 'Cochin'),
(10, 'Divya Kapoor', 'divya.kapoor@hdfc.com', 'Jaipur');


INSERT INTO customer (cid, name, email, addrs) VALUES
(1, 'Anil', 'ravi.kumar@hdfc.com', 'Bangalore'),
(2, 'Priya Sharma', 'priya.sharma@hdfc.com', 'Mumbai'),
(3, 'Arjun Mehta', 'arjun.mehta@hdfc.com', 'Delhi'),
(4, 'Sneha Iyer', 'sneha.iyer@hdfc.com', 'Chennai'),
(5, 'Vikram Singh', 'vikram.singh@hdfc.com', 'Hyderabad'),
(6, 'Anita Rao', 'anita.rao@hdfc.com', 'Pune'),
(7, 'Karan Patel', 'karan.patel@hdfc.com', 'Ahmedabad'),
(8, 'Meera Joshi', 'meera.joshi@hdfc.com', 'Kolkata'),
(9, 'Rahul Nair', 'rahul.nair@hdfc.com', 'Cochin'),
(10, 'Divya Kapoor', 'divya.kapoor@hdfc.com', 'Jaipur');





SELECT * FROM BANK.HDFC.CUSTOMER;



-- Create Employee table
CREATE OR REPLACE TABLE bank.HDFC.employee (
    employee_id INT PRIMARY KEY,
    first_name STRING,
    last_name STRING,
    email STRING,
    phone_number STRING,
    hire_date STRING,
    job_id INT,
    salary NUMBER(10,2),
    manager_id INT,
    department_id INT
);


SELECT * FROM bank.HDFC.employee;


----
delete from bank.HDFC.employee 
   where employee_id = 100 ;

delete from bank.HDFC.employee ;


truncate table  bank.HDFC.employee;



drop table bank.HDFC.employee;


   undrop table bank.HDFC.employee;


--------------------TASK ------

-- Create database   college 
-- create 3 schemas as Mits , vit , SGMS  
-- create student table sid name address , marks ,phone 
-- insert 10 records 
-- perfrom select , delete drop and trucntate 





-- Step 1: Create Database
CREATE DATABASE college;

-- Step 2: Create Schemas
CREATE SCHEMA college.mits;
CREATE SCHEMA college.vit;
CREATE SCHEMA college.sgms;

-- Step 3: Create Student table in each schema
CREATE OR REPLACE TABLE college.mits.student (
    sid INT PRIMARY KEY,
    name STRING,
    address STRING,
    marks INT,
    phone STRING
);



-- Step 4: Insert 10 records into MITS schema
INSERT INTO college.mits.student (sid, name, address, marks, phone) VALUES
(1, 'Ravi Kumar', 'Bangalore', 85, '9876543210'),
(2, 'Priya Sharma', 'Mumbai', 90, '9876543211'),
(3, 'Arjun Mehta', 'Delhi', 78, '9876543212'),
(4, 'Sneha Iyer', 'Chennai', 88, '9876543213'),
(5, 'Vikram Singh', 'Hyderabad', 92, '9876543214'),
(6, 'Anita Rao', 'Pune', 80, '9876543215'),
(7, 'Karan Patel', 'Ahmedabad', 76, '9876543216'),
(8, 'Meera Joshi', 'Kolkata', 89, '9876543217'),
(9, 'Rahul Nair', 'Cochin', 83, '9876543218'),
(10, 'Divya Kapoor', 'Jaipur', 91, '9876543219');

-- Step 5: Perform SELECT
SELECT * FROM college.mits.student;

-- Step 6: Perform DELETE (example: delete student with sid=5)
DELETE FROM college.mits.student WHERE sid = 5;

-- Step 7: Perform TRUNCATE (remove all rows but keep table structure)
TRUNCATE TABLE college.mits.student;

-- Step 8: Perform DROP (remove table completely)
DROP TABLE college.mits.student;

	 
	 
		
Displaying class-1.txt.