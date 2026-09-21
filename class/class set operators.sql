


-----windows functions
-----CTE
-----set operators

---*CTE= common tbale expressionit willact as like temptable/session 
---- set operators=union,union all ,nterset,minus

---window functions:
--


---*CTE= common tbale expressionit willact as like temptable/session 
select*from employees;
with cte_emp as
    (
    select*from employees
    )select*from cte_emp;

    
---to add like next hike
----(for adding the new colum like hike and given the5 or 10%  will use below code the specific is  (salary*10)/100 as next_hike )


                        --ex1for 5%
                        
select employee_ID,
    first_name,
    salary,
    (salary*5)/100 as next_hike
    from employees
    
                            --ex2 for 10%
                            

select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees

-----to find the who got the hike less than 500 or 600 or700 will add the (where next_hike< 500or 600or 700:)

    select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees
    where next_hike<500;     

-----there is a one more example with the differnt code(in the we have added the "with cte_sal as" and rest queary added in to the "()" and select *from cte_sal rest all remains the same

with cte_sal as
(
 select employee_ID,
    first_name,
    salary,
    (salary*10)/100 as next_hike
    from employees
)
select*from cte_sal
where next_hike<600;





----------set operators-----------
--there are 4 operators 
--1.UNION:it will remove the duplicates from query results
--2.INION ALL:it will not remove the duplicates from the query results
--3.INTERSECT: only common values will get print
--4.MINUS: it should present in only A not in B table(A-B)


--1.UNION;----
--its will remove douplicates

select employee_id from employees
    union
select employee_id from dependents;

--2.UNION ALL;----
--it will show all 

select employee_id from employees
    union all
select employee_id from dependents;

--3.INTERSECT----

select employee_id from employees
    intersect
select employee_id from dependents;

--4.MINUS----
select employee_id from employees
minus
select employee_id from dependents;

-----we can use multble also like--(in union place we can use union all intersect minus) below is just for ex
select employee_id,first_name from employees
 union
 select employee_id,first_name from dependents;

 ---what if we add CTE into the union,union all, minus.

 with cte_emp as
 (
select employee_id,first_name from employees
 union
 select employee_id,first_name from dependents
 )
 select* from cte_emp
 order by employee_id




 -------------window functions--------------
--ROW_NUMBER:
--RANK
--DENSE_RANK
--LEAD
--LAG



select employee_id,
    salary,
    row_number()over(order by salary desc)as RID,
     rank()over(order by salary desc)as RNK,
    dense_rank()over(order by salary desc)AS DRNK,
    LEAD (SALARY)OVER(ORDER BY SALARY DESC)AS NEXT_VAL,
    LAG (SALARY)OVER(ORDER BY SALARY DESC)AS NEXT_VAL
   from employees;

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