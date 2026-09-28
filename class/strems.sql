


class-17.txt
100%
                           Snowflake Training 
							     Class-17
							------------------------
							Streams & Tasks 
							SCD Types 
							
							
							
SCD -- Slowly changing dimensions 

Type-1 : It is overwrite the data 
           Bank -->     ph  --> 
		   
		   source table ------> Target table 
		   ph -123      ---->    123
		       145      ---->    145 
		   

Type-2 : Maintain full history of the data in row level 

         amazon --order tracking -->    history placed --> shipped --> dilevered 


Type-3 : Limited history 



1. Create Source table  from brnz layer 
2. Create Target table in slv layer 
3. Create a stream on top of source table 
4. Insert 1 or 2 records into source table and query the stream and verify 
5. Write a Merge SQL from source_stream and target table on top of this create a task 
6. Resume the task and insert records into source table 
7. Verify the final target table data 



Incremental Models 

source -- 1M  records   ---> target --> 1M 
  10 records insert    --> insert/update/delete should get process 
Displaying class-17.txt.