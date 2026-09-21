


class-5.txt
Page
1
/
1
100%
                            Snowflake Training 
							     Class-5
							------------------
							Windows functions 
							CTE 
							Set operators 
							
	CTE --- Common table expression it will act as like temp table / session table 
	
	
	with  cte_emp as 
	(
	   select * from emp 
	) select * from cte_emp  
	
	
	Set operators :
	
	A   B 
	
	
	UNION :  it will remove the duplicates from the query results 
	UNION ALL: it will not remove the duplciates from the query results 
	INTERSECT : Only the common values will get print 
	MINUES :   It should be present in only A not in B table  (A-B) 
	
	
Windows functions :

  ROW_NUMBER  :
  RANK 
  DENSE_RANK
  LEAD 
  LAG 
  
  
  
  tASK :
  
  
  MID    MONTH_NAME AMOUNT 
  ------------------------
  1     JAN         20000
  2      FEB         30000
  3      MAR        10000 
  ..
  ...
  ...
  12    DEC         45000
  
  
  I WNAT TO SEE PROFIT OR LOSS  (lEAD /LAG) 
  
    MID    MONTH_NAME AMOUNT      PROFIT_LOSS
  -----------------------------------------
  1     JAN         20000          nA
  2      FEB        30000        10000
  3      MAR        10000        -20000
  ..
  ...
  ...
  12    DEC         45000
  
  
 sql :
 --------------
 

WITH CTE_EMP AS 
(
  SELECT * FROM EMPLOYEES
)
SELECT * FROM CTE_EMP ;


 SELECT EMPLOYEE_ID,
      FIRST_NAME,
      SALARY ,
      (SALARY * 10 )/100  AS NEXT_HIKE 
      FROM EMPLOYEES
      WHERE NEXT_HIKE < 500 ;


WITH CTE_SAL AS 
(
   SELECT EMPLOYEE_ID,
      FIRST_NAME,
      SALARY ,
       (SALARY * 10 )/100  AS NEXT_HIKE 
      FROM EMPLOYEES
)
 SELECT *
      FROM CTE_SAL
      WHERE NEXT_HIKE < 500 ;




SELECT EMPLOYEE_ID FROM EMPLOYEES 
      UNION 
SELECT EMPLOYEE_ID FROM DEPENDENTS ;


SELECT EMPLOYEE_ID FROM EMPLOYEES 
      UNION ALL
SELECT EMPLOYEE_ID FROM DEPENDENTS ;



SELECT EMPLOYEE_ID FROM EMPLOYEES 
      INTERSECT
SELECT EMPLOYEE_ID FROM DEPENDENTS ;



SELECT EMPLOYEE_ID FROM EMPLOYEES 
      MINUS
SELECT EMPLOYEE_ID FROM DEPENDENTS ;


WITH CTE_EMP AS 
(
SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES 
      UNION 
SELECT EMPLOYEE_ID,FIRST_NAME FROM DEPENDENTS 
)  SELECT * FROM CTE_EMP 
  ORDER BY EMPLOYEE_ID 




WITH CTE_EMP AS 
(
SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES 
      UNION 
SELECT EMPLOYEE_ID,RELATIONSHIP FROM DEPENDENTS 
)  SELECT * FROM CTE_EMP 
  ORDER BY EMPLOYEE_ID 


SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES 
      UNION 
SELECT EMPLOYEE_ID,LAST_NAME FROM DEPENDENTS 




SELECT EMPLOYEE_ID ,
       SALARY,
       ROW_NUMBER()  OVER(ORDER BY SALARY DESC ) AS RID,
       RANK()  OVER(ORDER BY SALARY DESC ) AS RNK,
       DENSE_RANK()  OVER(ORDER BY SALARY DESC ) AS DRANK,
       LEAD(SALARY) OVER(ORDER BY SALARY DESC) AS NEXT_VAL,
         LAG(SALARY) OVER(ORDER BY SALARY DESC) AS PRE_VAL

       FROM EMPLOYEES 



-----BASED ON EMPLOYEE TABLE I WNAT TO FIND 3RD HIGHEST SAL 
---BASED ON EACH DEPARTMENT NEED HIGHEST SALRY 


SELECT * ,
DENSE_RANK()  OVER(ORDER BY SALARY DESC )  AS RNK
FROM EMPLOYEES 
WHERE RNK = 3   -- WRONG 


WITH CTE_EMP AS (
    SELECT * ,
    DENSE_RANK()  OVER(ORDER BY SALARY DESC )  AS RNK
    FROM EMPLOYEES 
) SELECT * FROM CTE_EMP WHERE RNK = 3



WITH CTE_EMP AS (
    SELECT * ,
    DENSE_RANK()  OVER(ORDER BY SALARY DESC )  AS RNK
    FROM EMPLOYEES 
) SELECT * FROM CTE_EMP WHERE RNK = 10



    SELECT * ,
    DENSE_RANK()  OVER(ORDER BY SALARY DESC )  AS RNK
    FROM EMPLOYEES 
    QUALIFY RNK = 13 



      SELECT * ,
      ROW_NUMBER()  OVER(PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC )  AS RNK
    FROM EMPLOYEES 
    QUALIFY RNK = 1
   

 
Displaying class-7.txt.