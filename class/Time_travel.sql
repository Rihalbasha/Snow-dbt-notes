



100%
                            Snowflake Training 
							     Class-15
							------------------------
							Time Travel & file safe 
							Zero Copy Cloning 
							
							
Time Travel : 
In order to fetch historical data(like accidentally deleted or updated data) we are going to use time travel , We can recover data up to 90 days.
	              By default retention period is 1 day 
		We can set up to 90 days 
		 3 ways to recover this 
				  
		  1)offset 
		  2)timestamp 
		  3)Query id
Once Time Travel period ended data will be moved to File Safe.
It’s Available (1 to 7-day recovery after Time Travel ends) Need to connect for snowflake Team
SELECT * FROM OUR_FIRST_DB.public.employees at (OFFSET => -60*1.5)
SELECT * FROM OUR_FIRST_DB.public.employees before (timestamp => '2025-09-23 04:40:15.000'::timestamp)
SELECT * FROM OUR_FIRST_DB.public.employees before (statement => '01bf3c5a-0001-63a1-000b-b8920004013e')
)
ALTER TABLE test SET DATA_RETENTION_TIME_IN_DAYS=30;



employee --->  40 

deleted --> 1st ---> 5 days 




Zero Copy Cloning:
	We can maintain multiple copies of data with no additional cost and storage  so we call zero copy.
	Create N number of copies of a database, a schema or a table
	Cloned object is independent from original
	Creating backups for development/testing  purposes
	NOTE: Temp table cannot be cloned to a permanent table clone to a transient table instead.
	But we can clone temporary to temporary 

CREATE TABLE <table_name> ... CLONE	<source_table_name>